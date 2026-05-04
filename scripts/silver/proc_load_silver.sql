/*
=======================================================
Stored Procedure: silver.load_silver
=======================================================
Script Purpose:
    - This stored procedure perfrom Extract, Transform, load process for loading the cleansed and transformed data from the bronze layer tables into the silver layer tables.
    - The duration of each load operation is measured and printed to the console for monitoring purposes.
    - The procedure is designed to be executed after the DDL structure of the silver tables has been defined using the ddl_silver.sql script.

Actions Performed:
    1. Truncate the existing data in the silver layer tables to ensure a fresh load.
    2. Insert transformed data into the silver layer tables from the bronze layer tables.
    3. Handle any errors that occur during the loading process and log them for troubleshooting.

Parameters:
    None - This procedure does not require any input parameters.
--------------------------------------------------

To execute the stored procedure and load the data into the silver layer, run the following command:
    EXEC silver.load_silver
    Go
*/

USE sql_DataWarehouse
GO

EXEC silver.load_silver
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

    DECLARE @startTime datetime, @endTime datetime, @batch_start_time datetime, @batch_end_time datetime

    PRINT ('>> Truncate the data inside the tables before loading the data into silver layer')
    SET @batch_start_time = GETDATE()
    BEGIN TRY
        PRINT ('=======================================================')
        PRINT ('Loading data into Silver layer...')
        PRINT ('=======================================================')

        PRINT ('-------------------------------------------------------')
        PRINT ('Staging data into CRM Tables...')
        PRINT ('-------------------------------------------------------')

        -- 1. Customer Info Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.crm_cust_info

        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,                              -- To remove unwanted whitespaces
            TRIM(cst_lastname) AS cst_lastname,                                -- To remove unwanted whitespaces
            CASE
            -- Standardizing Marital Status to 'Married' and 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                -- Handling missing values by filling them as 'n/a'
                ELSE 'n/a'
            END AS cst_marital_status,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'                    -- Standardizing Gender to 'Male' and 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                -- Handling missing values by filling them as 'n/a'
                ELSE 'n/a'
            END AS cst_gndr,
            cst_create_date
        FROM (
            SELECT
                *,
                -- To handle duplicates by keeping the latest record based on create date
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC)
                    AS flag_last
            FROM bronze.crm_cust_info
        -- To handle nulls in primary key by excluding those records
        ) AS t
        WHERE flag_last = 1 AND cst_id IS NOT null
        -- using subquery to filter out the latest record for each cst_id and also to exclude records with null cst_id

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 2. silver.crm_prd_info

        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.crm_prd_info

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            -- To handle and extract cat_id and prd_key from the original
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            -- To handle negative and null values in prd_cost by replacing them with 0
            ISNULL(prd_cost, 0) AS prd_cost,
            -- Standardizing Product Line values and handling missing values by filling them as 'n/a'
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            -- Casting date columns to date format
            CAST(prd_start_dt AS date) AS prd_start_dt,
            CAST(
                LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS date
            ) AS prd_end_dt
        FROM bronze.crm_prd_info

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 3. silver.crm_sales_details

        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.crm_sales_details

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_price,
            sls_quantity,
            sls_sales,
            sls_ship_dt,
            sls_due_dt,
            sls_order_dt
        )
        SELECT
            sls_ord_num,    -- checked out for unwanted spaces and not found any
            sls_prd_key,    -- checked for matching prd_key in silver.crm_prd_info
            sls_cust_id,    -- checked for matching cst_id in silver.crm_cust_info
            CASE
                WHEN sls_price = 0 OR sls_price IS null THEN sls_sales / NULLIF(sls_quantity, 0)
                WHEN sls_price < 0 THEN ABS(sls_price)
                ELSE sls_price
            END AS sls_price,
            sls_quantity,
            CASE
                WHEN sls_sales <= 0 OR sls_sales IS null OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,
            CAST(CAST(sls_ship_dt AS varchar) AS date) AS sls_ship_dt,
            -- dates were not in valid format, so converting them to valid date format in silver layer
            CAST(CAST(sls_due_dt AS varchar) AS date) AS sls_due_dt,
            CASE
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN null
                ELSE CAST(CAST(sls_order_dt AS varchar) AS date)
            END AS sls_order_dt
        FROM bronze.crm_sales_details

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 4. erp_cust_az12

        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.erp_cust_az12

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            SUBSTRING(cid, 4, LEN(cid)) AS cid,
            CASE
                WHEN bdate > GETDATE() THEN null
                ELSE bdate
            END AS bdate,
            CASE
                WHEN UPPER(TRIM(gen)) = 'M' OR UPPER(TRIM(gen)) = 'Male' THEN 'Male'
                WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
                ELSE 'n/a'
            END AS gen
        FROM bronze.erp_cust_az12

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 5. erp_loc_a101

        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.erp_loc_a101
        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid,
            CASE
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = 'UK' THEN 'United Kingdom'
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IS null OR TRIM(cntry) = '' THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry
        FROM bronze.erp_loc_a101

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 6. erp_px_cat_g1v2

        SET @startTime = GETDATE()
        TRUNCATE TABLE silver.erp_px_cat_g1v2

        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2

        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

    END TRY
    BEGIN CATCH
        PRINT ('Error occurred while loading data into Silver layer: ')
        PRINT ('Error Message: ' + ERROR_MESSAGE())
        PRINT ('Error Number: ' + CAST(ERROR_NUMBER() AS nvarchar(4000)))
        PRINT ('Error Message: ' + CAST(ERROR_STATE() AS nvarchar(4000)))
        PRINT ('=======================================================')
    END CATCH
    SET @batch_end_time = GETDATE()
    PRINT ('=======================================================')
    PRINT ('Silver layer load completed.')
    PRINT ('Total Load Duration:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS nvarchar(4000)) + ' seconds')
    PRINT ('=======================================================')
END
