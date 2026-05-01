/*
=============================================
Create Database and Schemas
=============================================
Script Purpose:
    This script creates a new database named 'sql_DataWarehouse' after checking if it already exists.
    If it exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'

Warning:
    Running this script will drop the entire 'sql_DataWarehouse' database if it already exists and had data in it. All the data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script.
*/

Use master
Go

-- Drop and recreate the database sql_DataWarehouse if already existed
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'sql_DataWarehouse')
BEGIN
    ALTER DATABASE sql_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE sql_DataWarehouse;
END;
GO

-- Create the database sql_DataWarehouse
create database sql_DataWarehouse

use sql_DataWarehouse
GO

-- Create the schemas
create schema bronze
GO

create schema silver
GO

create schema gold
go
