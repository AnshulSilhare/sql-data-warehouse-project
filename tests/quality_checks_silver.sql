/*
====================================================
Quality Checks for Silver Layer
====================================================
Script Purpose:
    This script performs data quality checks on the silver layer tables to ensure that the data has been correctly transformed and loaded from the bronze layer.
    The checks include:
        1. Null or Duplicate values in primary keys
        2. Unwanted spaces in string fields
        3. Data Standardization and Consistency
        4. Validity of date fields and order details
        5. Data type casting and format checks

Usage Notes:
    - Run this script after the data has been loaded into the silver layer tables using the proc_load_silver stored procedure.
    - Review the results of each check to identify any data quality issues that need to be addressed before moving the data to the gold layer.
    - Address any identified issues by correcting the data in the silver layer or by adjusting the transformation logic as needed.
===============================================================================
*/

-- ============================================================
-- 1. silver.crm_cust_info
-- =======================================================

-- Check for nulls or Duplicates in the primary key
-- Expectation: No nulls or duplicates should be found
SELECT
    cst_id,
    count(*) AS count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 OR cst_id IS null


-- Checkfor unwanted spaces
-- Expectation: No unwanted spaces should be found
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != trim(cst_key)

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != trim(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != trim(cst_lastname)

-- Data Standardization & Consistency Checks
-- Expectation: All entries should follow the same format
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

-- ============================================================
-- 2. silver.crm_prd_info
-- ----------------------------------------------------------

-- Check for nulls or Duplicates in the primary key
-- Expectation: No nulls or duplicates should be found
SELECT
    prd_id,
    count(*) AS count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 OR prd_id IS null

-- Checkfor unwanted spaces
-- Expectation: No unwanted spaces should be found
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != trim(prd_nm)

-- Check for NULLs or Negative Values in Cost
-- Expectation: No NULLs or negative values should be found in the cost column
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS null OR prd_cost < 0

-- Data Standardization & Consistency Checks
-- Expectation: All entries should follow the same format
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for valid dates in prd_start_dt and prd_end_dt
-- Expectation: No results should be found i.e. it satisfies the condition prd_end_dt > prd_start_dt
SELECT
    prd_id,
    prd_start_dt,
    prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ============================================================
-- 3. silver.sales_details
-- ----------------------------------------------------------

-- Check for Invalid Order, Ship, and Due Dates
-- Expectation: No results should be found i.e. it satisfies the conditions sls_order_dt <= sls_ship_dt and sls_order_dt <= sls_due_dt
SELECT *
FROM silver.crm_sales_details
WHERE
    sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No results should be found i.e. all records should satisfy the condition sls_sales = sls_quantity * sls_price
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE
    sls_sales != sls_quantity * sls_price
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
    OR sls_sales IS null
    OR sls_quantity IS null
    OR sls_price IS null
ORDER BY sls_sales, sls_quantity, sls_price

-- ============================================================
-- 4. silver.erp_cust_az12
-- ----------------------------------------------------------

-- Check for out of range or invalid dates in bdate
-- Expectation: No results should be found i.e. all dates should be between 1900-01-01 and 2050-01-01

SELECT
    cid,
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1900-01-01' OR bdate > '2050-01-01'

-- Data Standardization & Consistency Checks
-- Expectation: All entries should follow the same format
SELECT DISTINCT gen
FROM silver.erp_cust_az12

-- ============================================================
-- 5. silver.erp_loc_a101
-- ----------------------------------------------------------

-- Data Standardization & Consistency Checks
-- Expectation: All entries should follow the same format
SELECT DISTINCT cntry
FROM silver.erp_loc_a101

-- ============================================================
-- 6. silver.erp_px_cat_g1v2
-- ----------------------------------------------------------

-- Check for unwanted spaces
-- Expectation: No unwanted spaces should be found
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != trim(cat) OR subcat != trim(subcat) OR maintenance != trim(maintenance) OR id != trim(id)

-- Data Standardization & Consistency Checks
-- Expectation: All entries should follow the same format
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2
