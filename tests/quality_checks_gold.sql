/*
===============================================================================
Gold Layer - Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity,
    consistency, and accuracy of the Gold Layer views. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between the fact table and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after the Gold Layer views have been created.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'Gold.dim_customers'
-- ====================================================================
-- Check for duplicate customer surrogate keys
-- Every customer should have a unique customer_key
-- Expectation: No Results
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM Gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'Gold.dim_products'
-- ====================================================================
-- Check for duplicate product surrogate keys
-- Every product should have a unique product_key
-- Expectation: No Results
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM Gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'Gold.fact_sales'
-- ====================================================================
-- Check referential integrity between fact table and dimension tables
-- Every sales record should have a matching customer and product
-- Any NULL in customer_key or product_key means an orphaned sales record
-- Expectation: No Results
SELECT * 
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN Gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
