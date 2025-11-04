/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

WITH yearly_product_sales AS 
(
SELECT 
	p.product_name ,
	YEAR(f.order_date) as order_year ,
	SUM(f.sales_amount) as total_sales 
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON f.product_key = p.product_key
WHERE YEAR(f.order_date) IS NOT NULL 
GROUP BY p.product_name , YEAR(f.order_date)
)
	SELECT 
		product_name,
		order_year,
		total_sales,
		AVG(total_sales) OVER(PARTITION BY product_name) as avg_product_sales,
		total_sales - AVG(total_sales) OVER(PARTITION BY product_name) as diff_avg,
		CASE WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
			 WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
			 ELSE 'avg'
		END avg_change,
		LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) as previous_year,
		total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_py,
		CASE WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
			 WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
			 ELSE 'No Change'
		END as py_change 
	FROM yearly_product_sales
ORDER BY product_name , order_year;
