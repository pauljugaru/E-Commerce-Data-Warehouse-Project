-- Create Database 

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'ECommerce_DWH')
BEGIN
	ALTER DATABASE ECommerce_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE ECommerce_DWH;
END;
GO

CREATE DATABASE ECommerce_DWH;
GO

USE ECommerce_DWH;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO