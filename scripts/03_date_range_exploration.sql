/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
	MIN(order_date) AS First_order_date ,
	MAX(order_date) AS Last_order_date ,
	DATEDIFF(year , MIN(order_date) , MAX(order_date)) AS Order_Range_Years 
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT 
	MIN(birth_date) As Youngest_customer ,
	DATEDIFF(year , MIN(birth_date) , GETDATE() ) AS oldest_age ,
	MAX(birth_date) As oldest_customer ,
	DATEDIFF(year , MAX(birth_date) , GETDATE() ) AS youngest_age
FROM gold.dim_customers;
