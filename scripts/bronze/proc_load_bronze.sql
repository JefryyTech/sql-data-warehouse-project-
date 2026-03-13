-- =============================================================
-- Stored Procedure: Bronze.load_bronze
-- Purpose: Loads raw data into the Bronze layer tables
--          from CSV source files (CRM and ERP systems)
-- Description: Truncates and reloads all Bronze tables using 
--              BULK INSERT. Tracks load duration per table and 
--              total batch duration. Handles errors gracefully 
--              using TRY CATCH and prints detailed error info.
-- Usage: EXEC Bronze.load_bronze
-- Note: Update the file paths below to match your local 
--       dataset directory before executing
-- ==============================================================

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	
-----------------------------------------------------------------------------------------------------
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT 'Loading the Bronze Layer';
		PRINT '======================================================';
		PRINT '------------------------------------------------------';
		PRINT 'Loading the CRM Tables';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info;
		PRINT 'Inserting Data into: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\cust_info.csv'
		WITH 
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;
		PRINT 'Inserting Data into: Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\prd_info.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;
		PRINT 'Inserting Data into: Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_crm\sales_details.csv'
		WITH 
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

		PRINT '------------------------------------------------------';
		PRINT 'Loading the ERP Tables';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12;
		PRINT 'Inserting Data into: Bronze.erp_cust_az12';
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\cust_az12.csv'
		WITH 
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.erp_loc_a101';
		TRUNCATE TABLE Bronze.erp_loc_a101;
		PRINT 'Inserting Data into: Bronze.erp_loc_a101';
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\loc_a101.csv'
		WITH 
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT 'Truncating Table: Bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		PRINT 'Inserting Data into: Bronze.erp_px_cat_g1v2';
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\Users\YourUserName\Desktop\DataWarehouse_Project\datasets\source_erp\px_cat_g1v2.csv'
		WITH 
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '-----------------';

	SET @batch_end_time = GETDATE();
	PRINT '======================================================';
	PRINT 'Bronze Layer Loading Completed';
	PRINT 'Batch Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' secs';
	PRINT '======================================================';
		
	END TRY 
-----------------------------------------------------------------------------------------------------
	BEGIN CATCH
		PRINT '================================================================';
		PRINT 'ERROR OCCURED DURING THE LOADING PHASE OF THE BRONZE LAYER';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================';
	END CATCH
-----------------------------------------------------------------------------------------------------
END
