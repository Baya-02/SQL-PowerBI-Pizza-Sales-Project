--       Pizza Sales SQL Queries  

-- Creating Tables:
drop table if exists pizzas;
CREATE TABLE pizzas (
    pizza_id SERIAL PRIMARY KEY,           
    order_id INT NOT NULL,
    pizza_name_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    unit_price NUMERIC(6,2) NOT NULL,      
    total_price NUMERIC(6,2) NOT NULL,
    pizza_size VARCHAR(3) CHECK (pizza_size IN ('S', 'M', 'L', 'XL', 'XXL')),
    pizza_category VARCHAR(20),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);

select * from pizzas;

-- A. Customer's KPI’s:

-- 1. Total Revenue:
SELECT SUM(total_price) AS Total_Revenue FROM pizzas;


-- 2. Average Order Value
SELECT round((SUM(total_price) / COUNT(DISTINCT order_id)), 2) 
AS Avg_order_Value FROM pizzas;

-- 3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizzas;

-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizzas;

-- 5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizzas;

-- B. Daily Trend for Total Orders

SELECT 
  TRIM(TO_CHAR(order_date, 'Day')) AS order_day,
  EXTRACT(DOW FROM order_date) AS weekday_number,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizzas
GROUP BY order_day, weekday_number
ORDER BY (CASE 
              WHEN EXTRACT(DOW FROM order_date) = 0 THEN 7 
              ELSE EXTRACT(DOW FROM order_date) END);

-- C. Monthly Trend for Orders
SELECT 
  TO_CHAR(order_date, 'Month') AS month_name,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizzas
GROUP BY 
        TO_CHAR(order_date, 'Month'),
        EXTRACT(MONTH FROM order_date)
ORDER BY 
        EXTRACT(MONTH FROM order_date);


-- D. % of Sales by Pizza Category
SELECT pizza_category,
      CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
      CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizzas) 
	                                                 AS DECIMAL(10,2)) AS PCT
FROM pizzas
GROUP BY pizza_category;

-- E. % of Sales by Pizza Size

SELECT pizza_size, 
       CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizzas) 
	                                                  AS DECIMAL(10,2)) AS PCT
FROM pizzas
GROUP BY pizza_size
ORDER BY pizza_size;


-- G. Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
Limit 5;

-- H. Bottom 5 Pizzas by Revenue

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
Limit 5;

-- I. Top 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
Limit 5;


-- J. Bottom 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
Limit 5;

-- K. Top 5 Pizzas by Total Orders
SELECT  pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Orders DESC
Limit 5;

-- L. Bottom 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizzas
GROUP BY pizza_name
ORDER BY Total_Orders ASC
Limit 5;


