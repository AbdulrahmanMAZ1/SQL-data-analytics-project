/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking With TOP 
SELECT TOP 5 
	p.product_name ,
	SUM(f.sales_amount) as total_revenue 
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name 
ORDER BY total_revenue DESC;  

-- Complex but Flexibly Ranking Using Window Functions
SELECT * 
FROM (
SELECT 
	p.product_name ,
	SUM(f.sales_amount) as total_revenue ,
	ROW_NUMBER () OVER (ORDER BY SUM(f.sales_amount) DESC) as rank_products  
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name ) AS ranked_products 
WHERE rank_products <= 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT *
FROM (
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_customers
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
		 c.first_name,
		 c.last_name) AS ranked_customers 
WHERE rank_customers <= 10; 

-- The 3 customers with the fewest orders placed
SELECT 
	customer_key,
	first_name,
	last_name,
	rank_customers
FROM (
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT order_number) AS total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number)) AS rank_customers
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
		 c.first_name,
		 c.last_name) AS ranked_customers 
WHERE rank_customers <= 3;
