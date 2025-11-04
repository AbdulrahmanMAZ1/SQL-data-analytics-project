/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS Total_Sales FROM gold.fact_sales;

-- Find how many items are sold 
SELECT SUM(qunatity) AS Total_qunatity FROM gold.fact_sales;

-- Find the average selling price 
SELECT AVG(price) AS Avg_Price FROM gold.fact_sales;

-- Find the Total number of orders 
SELECT COUNT(DISTINCT order_number) AS Total_orders FROM gold.fact_sales; -- We removed the Duplicated orders 

-- Find the Total number of products 
SELECT COUNT(product_key) AS Correct_Number_products FROM gold.dim_products;

-- Find the Total number of customers 
SELECT COUNT(customer_key) AS Total_Nr_Customers FROM gold.dim_customers;


-- Find the Total number of customer that has placed an order
SELECT COUNT(DISTINCT customer_key) AS Correct_Total_Nr_Customers FROM gold.fact_sales;

-->> Generate a Report that shows all metrics of the business 
SELECT 'Total Sales' AS measure_name , SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Qunatity', SUM(qunatity) FROM gold.fact_sales
UNION ALL 
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Products', COUNT(product_key) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Customers', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
