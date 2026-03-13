CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @end_batch_time DATETIME;
	BEGIN TRY
		SET @start_batch_time = GETDATE();
		PRINT 'Loading the Silver Layer';
		PRINT '======================================================';
		PRINT '------------------------------------------------------';
		PRINT 'Loading the CRM Tables';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.crm_cust_info';
		TRUNCATE TABLE Silver.crm_cust_info;
		PRINT '>> Inserting Data Into: Silver.crm_cust_info';
		INSERT INTO Silver.crm_cust_info 
		(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status, 
			cst_gender,   
			cst_create_date
		)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE UPPER(TRIM(cst_marital_Status))
				 WHEN 'S' THEN 'Single'
				 WHEN 'M' THEN 'Married'
				 ELSE 'UNKNOWN'
			END AS cst_marital_status,
			CASE UPPER(TRIM(cst_gender)) 
				 WHEN 'F' THEN 'Female'
				 WHEN 'M' THEN 'Male'
				 ELSE 'UNKNOWN'
				 END AS cst_gender,
			cst_create_date
		FROM
		(
		SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM 
			bronze.crm_cust_info
		WHERE
			cst_id IS NOT NULL
		 )t WHERE flag_last = 1;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec'
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.crm_prd_info';
		TRUNCATE TABLE Silver.crm_prd_info;
		PRINT '>> Inserting Data Into: Silver.crm_prd_info';
		INSERT INTO Silver.crm_prd_info
		(
			prd_id,
			cat_id,
			prd_key,
			prd_name,
			prd_cost,
			prd_line,
			prd_start_date,
			prd_end_date
		)
		SELECT
			prd_id,  
			REPLACE(SUBSTRING(prd_key, 1, 5), '-' , '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			prd_name,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'R' THEN 'Road' 
				WHEN 'M' THEN 'Mountain'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'UNKNOWN'
			END AS prd_line,
			CAST(prd_start_date AS DATE) AS prd_start_date,
			CAST(LEAD(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date) - 1 AS DATE) AS prd_end_date
		FROM
			bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time)AS NVARCHAR) + ' sec'
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.crm_sales_details';
		TRUNCATE TABLE Silver.crm_sales_details;
		PRINT '>> Inserting Data Into: Silver.crm_sales_details';
		INSERT INTO Silver.crm_sales_details
		(
			sls_ord_num,
			sls_prd_num,
			sls_cust_id,
			sls_ord_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_price,
			sls_quantity
		)
		SELECT 
			sls_ord_num,
			sls_prd_num,
			sls_cust_id,
			CASE WHEN sls_ord_dt < 0 OR LEN(sls_ord_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ord_dt AS VARCHAR) AS DATE)
				 END AS sls_ord_dt,
			CASE WHEN sls_ship_dt < 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				 END AS sls_ship_dt,
			CASE WHEN sls_due_dt < 0 OR LEN(sls_due_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
				 END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
				 THEN sls_quantity * ABS(sls_price)
				 ELSE sls_sales 
			END AS sls_sales,
			CASE WHEN sls_price IS NULL OR sls_price <= 0 
				 THEN sls_sales / NULLIF(sls_quantity,0)
				 ELSE sls_price
			END AS sls_price,
			sls_quantity
		FROM
			Bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time)AS NVARCHAR) + ' sec'
		PRINT '-----------------';

		PRINT '------------------------------------------------------';
		PRINT 'Loading the ERP Tables';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.erp_cust_az12';
		TRUNCATE TABLE Silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: Silver.erp_cust_az12';
		INSERT INTO Silver.erp_cust_az12
		(
			cid,
			bdate,
			gender
		)
		SELECT 
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				 ELSE cid
			END cid,
			CASE WHEN bdate > GETDATE() THEN NULL
				 ELSE bdate
			END AS bdate,
			CASE WHEN UPPER(TRIM(gender)) IN ('F', 'Female') THEN 'Female'
				 WHEN UPPER(TRIM(gender)) IN ('M', 'Male') THEN 'Male'
				 ELSE 'UNKNOWN'
			END AS gender
		FROM 
			Bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time,@end_time)AS NVARCHAR) + ' sec'
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.erp_loc_a101';
		TRUNCATE TABLE Silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: Silver.erp_loc_a101';
		INSERT INTO Silver.erp_loc_a101
		(
			cid,
			cntry
		)
		SELECT 
			REPLACE(cid, '-', '') cid,
			CASE WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
				 WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'UNKNOWN'
				 ELSE TRIM(cntry)
			END AS cntry
		FROM
			bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time)AS NVARCHAR) + ' sec'
		PRINT '-----------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Silver.erp_px_cat_g1v2';
		TRUNCATE TABLE Silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: Silver.erp_px_cat_g1v2';
		INSERT INTO Silver.erp_px_cat_g1v2
		(
			id,
			cat,
			sub_cat,
			maintenance
		)
		SELECT
			id,
			cat,
			sub_cat,
			maintenance
		FROM
			Bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time)AS NVARCHAR) + ' sec'
		PRINT '-----------------';
		SET @end_batch_time = GETDATE();

	PRINT 'Batch Load Duration: ' + CAST(DATEDIFF(SECOND,@start_batch_time, @end_batch_time)AS NVARCHAR) + ' sec'
	END TRY
 
-----------------------------------------------------------------------------------------------------
	BEGIN CATCH
		PRINT '================================================================';
		PRINT 'ERROR OCCURED DURING THE LOADING PHASE OF THE SILVER LAYER';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================';
	END CATCH
-----------------------------------------------------------------------------------------------------
END
