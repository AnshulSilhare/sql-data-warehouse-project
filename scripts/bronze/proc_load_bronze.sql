USE sql_DataWarehouse
GO

/*
=======================================================
Stored Procedure: bronze.load_bronze
=======================================================
Description: This stored procedure is responsible for loading data from the source CSV files into the bronze layer tables.

- It uses the BULK INSERT command to efficiently load large volumes of data. - - The procedure also includes error handling to capture and log any issues that occur during the loading process.

- The duration of each load operation is measured and printed to the console for monitoring purposes.

- The procedure is designed to be executed after the DDL structure of the bronze tables has been defined using the ddl_bronze.sql script.
=======================================================

-- To execute the stored procedure and load the data into the bronze layer, run the following command:
                EXEC bronze.load_bronze
                Go
*/

-- Create or Alter Stored Procedure to load data into bronze layer
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @startTime datetime, @endTime datetime, @batch_start_time datetime, @batch_end_time datetime

    SET @batch_start_time = GETDATE()
    BEGIN TRY
        PRINT ('=======================================================')
        PRINT ('Loading data into Bronze layer...')
        PRINT ('=======================================================')

        PRINT ('-------------------------------------------------------')
        PRINT ('Staging data into CRM Tables...')
        PRINT ('-------------------------------------------------------')

        -- 1. Customer Info Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.crm_cust_info

        BULK INSERT bronze.crm_cust_info
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')
        -- check if each column got correct data
        -- Select Top 5 * from bronze.crm_cust_info
        -- check the number of rows inserted
        -- select count(*) from bronze.crm_cust_info

        -- 2. Product Info Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.crm_prd_info

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 3. Sales Details Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.crm_sales_details

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        PRINT ('-------------------------------------------------------')
        PRINT 'Staging data into ERP Tables...'
        PRINT ('-------------------------------------------------------')

        -- 4. Cust_AZ12 Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.erp_cust_az12

        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 5. Sales_AZ12 Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.erp_loc_a101

        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

        -- 6. Product_AZ12 Table Staging
        SET @startTime = GETDATE()
        TRUNCATE TABLE bronze.erp_px_cat_g1v2

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,1
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        SET @endTime = GETDATE()
        PRINT ('>> Load Duration:' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS nvarchar(4000)) + ' seconds')
        PRINT ('----------------------------------------------------')

    END TRY
    BEGIN CATCH
        PRINT ('=======================================================')
        PRINT ('Error occurred while loading data into Bronze layer:')
        PRINT ('Error Message: ' + ERROR_MESSAGE())
        PRINT ('Error Number: ' + CAST(ERROR_NUMBER() AS nvarchar(4000)))
        PRINT ('Error Message: ' + CAST(ERROR_STATE() AS nvarchar(4000)))
        PRINT ('=======================================================')
    END CATCH
    SET @batch_end_time = GETDATE()
    PRINT ('=======================================================')
    PRINT ('Bronze layer load completed.')
    PRINT ('Total Load Duration:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS nvarchar(4000)) + ' seconds')
    PRINT ('=======================================================')
END

SELECT TOP 7 * FROM bronze.crm_cust_info
