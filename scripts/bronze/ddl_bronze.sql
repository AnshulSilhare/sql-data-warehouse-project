/*
======================================================
DDL Script: Create tables in the bronze layer
======================================================
This script creates the necessary tables in the bronze layer to stage the raw data from the source systems. The tables are designed to hold the data as it is ingested, without any transformations or cleansing applied. The structure of the tables is based on the source data files, and they will serve as the landing zone for the raw data before it is processed and moved to the silver layer.
Run this script to re-define the DDL structure of bronze Tables.
======================================================
*/


If object_ID ('bronze.crm_cust_info', 'U') IS not null
    drop table bronze.crm_cust_info
create table bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
)

If object_ID ('bronze.crm_prd_info', 'U') IS not null
    drop table bronze.crm_prd_info
create table bronze.crm_prd_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
)

If object_ID ('bronze.crm_sales_details', 'U') IS not null
    drop table bronze.crm_sales_details
create table bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
)

If object_ID ('bronze.erp_cust_az12', 'U') IS not null
    drop table bronze.erp_cust_az12
create table bronze.erp_cust_az12 (
CID NVARCHAR(50),
BDATE Date,
GEN NVARCHAR(50)
)

If object_ID ('bronze.erp_loc_a101', 'U') IS not null
    drop table bronze.erp_loc_a101
create table bronze.erp_loc_a101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
)

If object_ID ('bronze.erp_px_cat_g1v2', 'U') IS not null
    drop table bronze.erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2 (
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
)
