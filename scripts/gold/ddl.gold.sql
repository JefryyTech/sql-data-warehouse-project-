/*
===============================================================================
Gold Layer Views
===============================================================================
Script Purpose:
    This script creates the Gold layer views for the data warehouse.
    The Gold layer represents the final dimension and fact tables used
    for reporting and analytics in Power BI.

    The following views are created:
    - gold.dim_customers: Customer dimension combining CRM and ERP data,
      including demographics, location, and gender resolution logic.
    - gold.dim_products: Product dimension combining CRM product data
      with ERP category data, filtered to active products only.
    - gold.fact_sales: Fact table linking sales transactions to the
      customer and product dimensions via surrogate keys.

Usage Notes:
    - Run this script after the Silver layer has been fully loaded.
    - These views query Silver layer tables directly and always reflect
      the most current data.
    - Execute EXEC Silver.load_silver before running reports or
      refreshing the Power BI dashboard.
===============================================================================
*/

-- =============================================================================
 -- Create Dimension: gold.dim_customers
 -- =============================================================================
 IF OBJECT_ID('Gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW Gold.dim_customers;
GO
 CREATE VIEW Gold.dim_customers AS
 SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate Key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gender != 'UNKNOWN' THEN ci.cst_gender
		 ELSE COALESCE(ca.gender,'UNKNOWN') 
	END AS gender,
	ca.bdate AS birthday,
	ci.cst_create_date AS create_date
FROM 
	silver.crm_cust_info AS ci
LEFT JOIN 
	silver.erp_cust_az12 AS ca
ON 
	ci.cst_key = ca.cid
LEFT JOIN 
	silver.erp_loc_a101 AS cl
ON
	ci.cst_key = cl.cid  
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('Gold.dim_products', 'V') IS NOT NULL
	DROP VIEW Gold.dim_products;
GO

CREATE VIEW Gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_date, pd.prd_key) AS product_key, -- Surrogate Key
	pd.prd_id AS product_id,
	pd.prd_key AS product_number,
	pd.prd_name AS product_name,
	pd.cat_id AS category_id,
	pc.cat AS category,
	pc.sub_cat AS subcategory,
	pc.maintenance,
	pd.prd_cost AS cost,
	pd.prd_line AS product_line,
	pd.prd_start_date AS start_date
FROM 
	silver.crm_prd_info AS pd
LEFT JOIN 
	silver.erp_px_cat_g1v2 AS pc
ON
	pd.cat_id = pc.id
WHERE
	prd_end_date IS NULL
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

IF OBJECT_ID('Gold.fact_sales' , 'V') IS NOT NULL
	DROP VIEW Gold.fact_sales;
GO
CREATE VIEW Gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_ord_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM
	Silver.crm_sales_details AS sd
LEFT JOIN 
	gold.dim_products AS pr
ON
	sd.sls_prd_num = pr.product_number
LEFT JOIN 
	gold.dim_customers AS cu
ON 
	sd.sls_cust_id = cu.customer_id
GO
	
	 



