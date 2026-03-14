# Gold Layer Data Catalog

## Overview
The Gold Layer represents the final analytical model of the data warehouse.
It is built on top of the Silver Layer and is optimized for reporting and analytics in Power BI.
All tables in this layer follow a Star Schema design with dimension and fact tables.

---

## Tables

### 1. gold.dim_customers
**Description:** Customer dimension table combining CRM and ERP source data.
Contains cleaned and enriched customer information including demographics and location.

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key, unique identifier generated for each customer |
| customer_id | INT | Original customer ID from the CRM system |
| customer_number | NVARCHAR(50) | Business key for the customer from the CRM system |
| first_name | NVARCHAR(50) | Customer first name, trimmed of whitespace |
| last_name | NVARCHAR(50) | Customer last name, trimmed of whitespace |
| country | NVARCHAR(50) | Customer country from the ERP location table |
| marital_status | NVARCHAR(50) | Marital status, standardized to Single, Married, or UNKNOWN |
| gender | NVARCHAR(50) | Gender resolved from CRM first, ERP used as fallback, standardized to Male, Female, or UNKNOWN |
| birthday | DATE | Customer date of birth from ERP, future dates set to NULL |
| create_date | DATE | Date the customer record was created in the CRM system |

---

### 2. gold.dim_products
**Description:** Product dimension table combining CRM product data with ERP category data.
Contains only currently active products where no end date exists.

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key, unique identifier generated for each product |
| product_id | INT | Original product ID from the CRM system |
| product_number | NVARCHAR(50) | Business key for the product from the CRM system |
| product_name | NVARCHAR(50) | Product name, trimmed of whitespace |
| category_id | NVARCHAR(50) | Derived category ID extracted from the product key |
| category | NVARCHAR(50) | Product category from the ERP category table |
| subcategory | NVARCHAR(50) | Product subcategory from the ERP category table |
| maintenance | NVARCHAR(50) | Maintenance type or flag from the ERP category table |
| cost | INT | Product cost, NULL values replaced with 0 |
| product_line | NVARCHAR(50) | Product line standardized to Road, Mountain, Other Sales, Touring, or UNKNOWN |
| start_date | DATE | Date the product version became active |

---

### 3. gold.fact_sales
**Description:** Fact table containing all sales transactions.
Links to dim_customers and dim_products via surrogate keys.
Used as the primary table for sales reporting and analytics in Power BI.

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Unique sales order identifier from the CRM system |
| product_key | INT | Foreign key linking to gold.dim_products |
| customer_key | INT | Foreign key linking to gold.dim_customers |
| order_date | DATE | Date the order was placed, invalid dates set to NULL |
| shipping_date | DATE | Date the order was shipped, invalid dates set to NULL |
| due_date | DATE | Date the order was due, invalid dates set to NULL |
| sales_amount | INT | Total sales amount, derived from quantity multiplied by price if original value is invalid |
| quantity | INT | Number of units sold |
| price | INT | Unit price, derived from sales divided by quantity if original value is invalid |

---

## Data Model
The Gold Layer follows a Star Schema design:

- gold.fact_sales is the central fact table
- gold.dim_customers and gold.dim_products are the dimension tables
- fact_sales joins to dim_customers on customer_key
- fact_sales joins to dim_products on product_key

---

## Source Tables
| Gold Table | Silver Source Tables |
|---|---|
| gold.dim_customers | Silver.crm_cust_info, Silver.erp_cust_az12, Silver.erp_loc_a101 |
| gold.dim_products | Silver.crm_prd_info, Silver.erp_px_cat_g1v2 |
| gold.fact_sales | Silver.crm_sales_details, gold.dim_products, gold.dim_customers |

---

## Notes
- All views in the Gold Layer query Silver tables directly and always reflect the most current data.
- Run EXEC Silver.load_silver before refreshing the Power BI dashboard.
- Surrogate keys are generated using ROW_NUMBER() and are not persistent across reloads.
