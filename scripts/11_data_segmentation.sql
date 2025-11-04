/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/* Segment products into cost ranges 
and count how many products fall into each segment*/

WITH product_segment AS 
(
SELECT 
	product_key,
	product_name,
	cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range 
FROM gold.dim_products  
) 
SELECT 
	cost_range,
	COUNT(product_key) as total_products 
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC; 

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_info AS 
(
SELECT 
	c.customer_key,
	SUM(f.sales_amount) as total_sales,
	DATEDIFF(month , MIN(order_date) , MAX(order_date)) as life_span
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
) 
SELECT 
	segmantation,
	COUNT(customer_key) as total_customers
FROM 
(
SELECT 
	customer_key,
	total_sales,
	life_span,
CASE WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN life_span >= 12 AND total_sales < 5000 THEN 'Regular'
	 ELSE 'New'
END as segmantation 
FROM customer_info
) t 
GROUP BY segmantation
ORDER BY total_customers DESC;
