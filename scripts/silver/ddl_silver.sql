-- =============================================================
-- Create Silver Schema Tables
-- Silver layer stores raw data loaded directly from source systems
-- CRM = Customer Relationship Management data
-- ERP = Enterprise Resource Planning data
-- =============================================================

-- CRM Tables

-- Drop and recreate table: stores raw customer information from CRM

IF OBJECT_ID ('Silver.crm_cust_info', 'U') IS NOT NULL
DROP TABLE Silver.crm_cust_info;
CREATE TABLE Silver.crm_cust_info
(
cst_id	INT,           -- Unique customer ID
cst_key NVARCHAR (50), -- Business key for the customer
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gender NVARCHAR(50),
cst_create_date DATE,   -- Date the customer record was created
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);


-- Drop and recreate table: stores clean product information from CRM
IF OBJECT_ID ('Silver.crm_prd_info','U') IS NOT NULL
DROP TABLE Silver.crm_prd_info;
CREATE TABLE Silver.crm_prd_info
(
prd_id INT,              -- Unique product ID
cat_id NVARCHAR (50),
prd_key NVARCHAR(50),    -- Business key for the product
prd_name NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),   -- Product line category
prd_start_date DATE, -- Date product became active
prd_end_date DATE,    -- Date product was discontinued
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);


-- Drop and recreate table: stores raw sales transaction data from CRM
IF OBJECT_ID ('Silver.crm_sales_details', 'U') IS NOT NULL
DROP TABLE Silver.crm_sales_details;
CREATE TABLE Silver.crm_sales_details
(
sls_ord_num NVARCHAR (50),  -- Sales order number
sls_prd_num NVARCHAR (50),  -- Product number on the order
sls_cust_id INT,            -- Customer who placed the order
sls_ord_dt DATE,             -- Order date
sls_ship_dt DATE,            -- Ship date
sls_due_dt DATE,             -- Due date
sls_sales INT,              -- Total sales amount
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);

-- ERP Tables

-- Drop and recreate table: stores raw customer demographics from ERP
IF OBJECT_ID ('Silver.erp_cust_az12', 'U') IS NOT NULL
DROP TABLE Silver.erp_cust_az12;
CREATE TABLE Silver.erp_cust_az12
(
cid NVARCHAR (50),    -- Customer ID matching CRM customer key
bDate DATE,           -- Customer date of birth
gender NVARCHAR (50),
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);


-- Drop and recreate table: stores raw customer location data from ERP
IF OBJECT_ID ('Silver.erp_loc_a101', 'U') IS NOT NULL
DROP TABLE Silver.erp_loc_a101;
CREATE TABLE Silver.erp_loc_a101
(
cid NVARCHAR(50),     -- Customer ID matching CRM customer key
cntry NVARCHAR(50),    -- Country of the customer
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);


-- Drop and recreate table: stores raw product category data from ERP
IF OBJECT_ID('Silver.erp_px_cat_g1v2' , 'U') IS NOT NULL
DROP TABLE Silver.erp_px_cat_g1v2;
CREATE TABLE Silver.erp_px_cat_g1v2
(
id NVARCHAR(50),           -- Product ID
cat NVARCHAR(50),          -- Product category
sub_cat NVARCHAR(50),      -- Product sub category
maintenance NVARCHAR(50),   -- Maintenance flag or type
dwh_create_date DATETIME2 DEFAULT GETDATE() 
);
