/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique marital statuses for our customers
SELECT DISTINCT marital_status 
FROM gold.dim_customers
ORDER BY marital_status;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT
category , subcategory , product_name
FROM gold.dim_products
ORDER BY category , subcategory , product_name;
