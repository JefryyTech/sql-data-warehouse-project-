# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository!

Building a modern data warehouse with SQL server, including ETL, processes, data modeling, and analytics.

---

## 📋 Project Requirements

### 🛠️👷 Building the Data Warehouse (Data Engineering) 

#### Objective
Develop a modern data warehouse suing SQL server to consolidate sales data, enabling analytical reporting and informed descion-making.

#### Specifications
-🛢️ **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files. 

-💎 **Data Quality**: Cleanse and resolve data quality issues prior to analysis.

-🔀**Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.

-🔎 **Scope**: Focus on the latest dataset only; historization of data is not required.

-📝**Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.


---

### 📊👩🏻‍🏫 BI: Analytics & Reporting (Data Analytics) 

#### Objective
Develop SQL-based analytics to deliver detailed insights into:

-👨🏻‍👩🏻‍👦🏻‍👦🏻 **Customer Behavior** 

-📦 **Product Performance**

-💲 **Sales Trends** 

These insights empower stakeholders with key business metrics, enabling strategic decision-making.
---
## 🏭 Data Warehouse

### High Level Architecture
The project follows a medallion architecture with three layers, each serving a distinct purpose in the data pipeline.

<img width="912" height="745" alt="Image" src="https://github.com/user-attachments/assets/2d2f0b87-2555-49dc-adbe-451cbf8b6e0f" />

**Sources**
- CRM and ERP systems provide raw data as CSV files stored in a local folder.

**Bronze Layer**
- Object Type: Tables
- Stores raw data exactly as it arrives from the source with no transformations applied.
- Load Strategy: Batch processing, full load using Truncate and Insert.

**Silver Layer**
- Object Type: Tables
- Stores cleaned and transformed data ready for analytical modeling.
- Load Strategy: Batch processing, full load using Truncate and Insert.
- Transformations applied: Data cleansing, standardization, normalization, derived columns, and data enrichment.

**Gold Layer**
- Object Type: Views
- Stores business ready data modeled into a Star Schema for reporting and analytics.
- No load required, views query Silver tables directly and always reflect current data.
- Transformations applied: Data integrations, aggregations, and business logic.

**Consumers**
- Power BI for BI and reporting.
- Ad hoc SQL queries for direct data exploration.
---
## Data Flow

The diagram below illustrates how data moves through each layer of the warehouse,
from raw source files to the final analytical model.

<img width="951" height="462" alt="Image" src="https://github.com/user-attachments/assets/3dc1903c-0165-4e2c-a344-23c35cbab236" />

### Data Flow Overview

**Sources**
- CRM system provides: crm_sales_details, crm_cust_info, crm_prd_info
- ERP system provides: erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2

**Bronze Layer**
- All 6 source tables are ingested as-is into the Bronze layer with no transformations.

**Silver Layer**
- All 6 Bronze tables are cleaned, standardized, and transformed into their
  corresponding Silver tables.

**Gold Layer**
- Silver tables are integrated and modeled into 3 analytical objects:
  - gold.fact_sales: Central fact table for sales transactions
  - gold.dim_customers: Customer dimension combining CRM and ERP customer data
  - gold.dim_products: Product dimension combining CRM and ERP category data
---

<img width="941" height="541" alt="Image" src="https://github.com/user-attachments/assets/f877472a-cdc3-42aa-9346-2dbc7528829f" />

---

## About Me
