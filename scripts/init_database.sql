/* 
===================================================================
Create Database and Schemas
===================================================================
Script Purpose:
    This script creates a Database called 'DataWarehouse' after already checking if it exists. 
    If it exists the database is dropped and recreated. Additionally the script creates three schemas
    within the database 'Bronze', 'Silver' and 'Gold'.
*/
USE master;
GO
  
-- Drop and recreate the 'DataWarehouse' database 
  IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
  BEGIN 
        ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE DataWarehouse;
  END;
GO

  -- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO
  
USE DataWareHouse;

-- Create the Schemas
CREATE SCHEMA Bronze;
GO
  
CREATE SCHEMA Silver;
GO
  
CREATE SCHEMA Gold;
GO
