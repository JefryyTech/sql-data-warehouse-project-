-- =============================================================
-- Stored Procedure: Bronze.load_bronze
-- Purpose: Truncates and reloads all Bronze layer tables
-- from raw CSV source files (CRM and ERP systems)
-- To execute: EXEC Bronze.load_bronze
-- =============================================================

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	-- -------------------------------------------------------------
	-- CRM Tables
	-- Source: Customer Relationship Management system
	-- -------------------------------------------------------------

	-- Load raw customer information
	TRUNCATE TABLE Bronze.crm_cust_info;
	BULK INSERT Bronze.crm_cust_info
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\cust_info.csv'
	WITH 
	(
		FIRSTROW = 2,          -- Skip header row
		FIELDTERMINATOR = ',', -- CSV comma separator
		TABLOCK                -- Lock table for faster load
	);

	-- Load raw product information
	TRUNCATE TABLE Bronze.crm_prd_info;
	BULK INSERT Bronze.crm_prd_info
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\prd_info.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Load raw sales transaction details
	TRUNCATE TABLE Bronze.crm_sales_details;
	BULK INSERT Bronze.crm_sales_details
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\sales_details.csv'
	WITH 
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- -------------------------------------------------------------
	-- ERP Tables
	-- Source: Enterprise Resource Planning system
	-- -------------------------------------------------------------

	-- Load raw customer demographics
	TRUNCATE TABLE Bronze.erp_cust_az12;
	BULK INSERT Bronze.erp_cust_az12
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\cust_az12.csv'
	WITH 
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Load raw customer location data
	TRUNCATE TABLE Bronze.erp_loc_a101;
	BULK INSERT Bronze.erp_loc_a101
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\loc_a101.csv'
	WITH 
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Load raw product category data
	TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
	BULK INSERT Bronze.erp_px_cat_g1v2
	FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\px_cat_g1v2.csv'
	WITH 
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

END
