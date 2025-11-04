/*
===============================================================================
#2 Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================*/

-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID ('gold.report_products' , 'V') IS NOT NULL
	DROP VIEW gold.report_products
GO 

CREATE VIEW gold.report_products AS 

WITH base_query AS 
(
/*---------------------------------------------------
1) Base Query: Retrieve core columns from tables 
-----------------------------------------------------*/
SELECT 
	f.order_number,
	f.order_date,
	f.sales_amount,
	f.qunatity,
	c.customer_number,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL
) 
, product_aggregation AS 
(
/*---------------------------------------------------------------------
2) Product Aggregations: Summarize Key metrics at the product level  
----------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	MAX(order_date) AS last_orders,
	COUNT(DISTINCT order_number) AS total_orders,
	DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales,
	SUM(qunatity) AS total_quantity,
	COUNT(DISTINCT customer_number) AS total_customers,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(qunatity,0)),1) AS avg_selling_price 
FROM base_query
GROUP BY product_key,
		 product_name,
		 category,
		 subcategory,
		 cost
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	lifespan,
	cost,
	total_orders,
	total_sales,
	avg_selling_price,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_quantity,
	total_customers,
	DATEDIFF(month,last_orders,GETDATE()) AS recency,

	-- Average Order Revenue (AOR)
	CASE WHEN total_sales = 0 THEN 0 
		 ELSE total_sales / total_orders 
	END as average_order_revenue,

	-- Average Monthly Revenue
	CASE WHEN total_sales = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS average_monthly_revenue
FROM product_aggregation;
