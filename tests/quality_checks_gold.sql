/*
===========================================================
Quality Checks - Gold Layer
===========================================================
Script Purpose:
    This script performs data quality checks on the gold layer views to ensure the integrity, consistency, and accuracy of the data before it is used for reporting and analysis.
    The checks include:
        1. Null or Duplicate values in surrogate keys
        2. Referential integrity checks between dimension and fact tables
        3. Relationship checks to ensure that the data validity is maintained across the star schema for analysis and reporting purposes.

Usage Notes:
    - Run this script after the gold layer views have been created using the ddl_gold.sql script.
    - Review the results of each check to identify any data quality issues that need to be addressed before using the gold layer for reporting and analysis.
    - Address any identified issues by correcting the data in the silver layer or by adjusting the transformation logic in the gold layer views as needed.
*/

-- ============================================================
-- 1. gold.dim_customers
-- =======================================================

-- Check for nulls or Duplicates in the surrogate key i.e. customer_key
-- Expectation: No nulls or duplicates should be found
SELECT
    customer_key,
    count(*) AS count_duplicates
FROM gold.dim_customers
GROUP BY customer_key
HAVING count(*) > 1 OR customer_key IS null

-- ============================================================
-- 2. gold.dim_products
-- =======================================================

-- Check for nulls or Duplicates in the surrogate key i.e. product_key
-- Expectation: No nulls or duplicates should be found
SELECT
    product_key,
    count(*) AS count_duplicates
FROM gold.dim_products
GROUP BY product_key
HAVING count(*) > 1 OR product_key IS null

-- ============================================================
-- 3. gold.fact_sales
-- =======================================================

-- Check the data model relationships and referential integrity between fact_sales and dim_products, dim_customers tables
-- Expectation: All product keys and customer keys in fact_sales should have matching records in dim_products and dim_customers tables respectively
SELECT *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
WHERE p.product_key IS null OR c.customer_key IS null
