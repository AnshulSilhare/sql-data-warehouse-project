use sql_DataWarehouse
go

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
Create or Alter Procedure bronze.load_bronze as
Begin
    Declare @startTime datetime, @endTime datetime, @batch_start_time Datetime, @batch_end_time DATETIME

    set @batch_start_time = GetDate()
    Begin Try
    Print ('=======================================================')
    Print 'Loading data into Bronze layer...'
    Print ('=======================================================')

    Print ('-------------------------------------------------------')
    Print 'Staging data into CRM Tables...'
    Print ('-------------------------------------------------------')

    -- 1. Customer Info Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.crm_cust_info

    Bulk Insert bronze.crm_cust_info
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')
    -- check if each column got correct data
    -- Select Top 5 * from bronze.crm_cust_info
    -- check the number of rows inserted
    -- select count(*) from bronze.crm_cust_info


    -- 2. Product Info Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.crm_prd_info

    Bulk Insert bronze.crm_prd_info
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')

    -- 3. Sales Details Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.crm_sales_details

    Bulk Insert bronze.crm_sales_details
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')

    Print ('-------------------------------------------------------')
    Print 'Staging data into ERP Tables...'
    Print ('-------------------------------------------------------')

    -- 4. Cust_AZ12 Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.erp_cust_az12

    Bulk Insert bronze.erp_cust_az12
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')

    -- 5. Sales_AZ12 Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.erp_loc_a101

    Bulk Insert bronze.erp_loc_a101
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')

    -- 6. Product_AZ12 Table Staging
    set @startTime = GetDate()
    Truncate Table bronze.erp_px_cat_g1v2

    Bulk Insert bronze.erp_px_cat_g1v2
    from 'D:\Repositories\Project Files\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    with (
        Firstrow = 2,
        FieldTerminator = ',',
        Tablock
    )
    set @endTime = GetDate()
    Print('>> Load Duration:' + cast(DATEDIFF(second, @startTime, @endTime) as nvarchar(4000)) + ' seconds')
    print ('----------------------------------------------------')

    End TRY
    Begin Catch
        Print ('=======================================================')
        Print 'Error occurred while loading data into Bronze layer:'
        Print 'Error Message: ' + ERROR_MESSAGE()
        Print 'Error Number: ' + Cast(ERROR_Number() As NVARCHAR(4000))
        Print 'Error Message: '  +Cast(ERROR_State() As NVARCHAR(4000))
        Print ('=======================================================')
    End Catch
    set @batch_end_time = GetDate()
    Print ('=======================================================')
    Print 'Bronze layer load completed.'
    Print('Total Load Duration:' + cast(DATEDIFF(second, @batch_start_time, @batch_end_time) as nvarchar(4000)) + ' seconds')
    Print ('=======================================================')
End
