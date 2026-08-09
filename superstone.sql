
CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date TEXT,
    ship_date TEXT,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales NUMERIC,
    quantity INT,
    discount NUMERIC,
    profit NUMERIC
);
DROP TABLE IF EXISTS superstore;


SELECT *
FROM superstore
LIMIT 10;

--Q1. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM superstore;

--Q2. Total Sales
SELECT SUM(sales)AS Total_Sale FROM superstore;

--Q3. Total Profit
SELECT SUM(profit)AS Total_profit FROM superstore;

--Q4. Average Sales per Order
SELECT ROUND(AVG(sales),2) AS average_sale 
FROM superstore


--Q5. Highest Sale
SELECT MAX(sales) AS highest_sale
FROM superstore;

--Q6. Lowest Sale
SELECT MIN(sales) AS lowest_sale
FROM superstore;

--Q7. Total Customers
SELECT COUNT(DISTINCT customer_id)
FROM superstore;

--Q8. Total Products
SELECT COUNT(DISTINCT product_name)
FROM superstore;

--Q9. Total Cities
SELECT  COUNT(DISTINCT city) AS Total_city
FROM superstore;

--Q10. Total States
SELECT  COUNT(DISTINCT state) AS Total_state
FROM superstore;


-- Q1 Top 10 products by total sales.
SELECT product_name,SUM(sales)AS Total_sale FROM superstore
GROUP BY product_name
ORDER BY Total_sale DESC LIMIT 10;

--Q2 Top 10 customers by total profit.
SELECT customer_name,SUM(profit)AS Total_Profit FROM superstore
GROUP BY customer_name 
ORDER BY Total_profit DESC LIMIT 10;

--Q3 Category-wise sales.
SELECT category,
       SUM(sales) AS total_sales
FROM superstore
GROUP BY category;

--Q4 Category-wise profit
SELECT category,SUM(profit) FROM superstore
GROUP BY category;

--Q5 State-wise total sales.
SELECT state,SUM(sales) FROM superstore
GROUP BY state;

-- Q6 Top 5 states by profit
SELECT state,
       SUM(profit) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_profit DESC
LIMIT 5;

--Q7 Which category generated the highest sales?
SELECT category,SUM(sales)AS Total_sale FROM superstore
GROUP BY category 
ORDER BY Total_sale DESC LIMIT 1;

--Q8 Which product generated the highest profit?
SELECT product_name,SUM(profit)AS Total_profit FROM superstore
GROUP BY product_name 
ORDER BY Total_profit DESC LIMIT 1;

--Q9 Which customer placed the most orders?
SELECT customer_name,
       COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_name
ORDER BY total_orders DESC
LIMIT 1;

--Q10 Top 5 cities by sales.
SELECT city,SUM(sales)AS Total_sale FROM superstore
GROUP BY city 
ORDER BY Total_sale DESC LIMIT 5;



--Q1 Top 10 loss-making products.
SELECT product_name,SUM(profit)AS Total_profit
FROM superstore GROUP BY product_name
ORDER BY Total_profit ASC LIMIT 10;


-- Q2 Top 10 loss-making customers.
SELECT customer_name,
       SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_name
ORDER BY total_profit ASC
LIMIT 10;

--Q3 Har region ki total sales aur profit.
SELECT region,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM superstore
GROUP BY region;

--Q4 Kis subcategory ne sabse zyada profit generate kiya?
SELECT sub_category,SUM(profit) AS Total_sale
FROM superstore GROUP BY sub_category
ORDER BY Total_sale DESC;

--Q5 Kis subcategory me sabse zyada loss hua?
SELECT sub_category,SUM(profit) AS Total_sale
FROM superstore GROUP BY sub_category
ORDER BY Total_sale ASC;

--Q6 Har ship mode ki total sales.
SELECT ship_mode,SUM(sales)
FROM superstore GROUP BY ship_mode;

--Q7 Average discount har category ke liye.
SELECT category,ROUND(AVG(discount),2)AS Average_dis
FROM superstore GROUP BY category;

--Q8 Top 10 orders with highest sales.
SELECT order_id,SUM(sales)AS Total_sale
FROM superstore GROUP BY order_id 
ORDER BY Total_sale DESC LIMIT 10;

--Q9 Profit margin (%) category-wise.
SELECT category,SUM(sales),SUM(profit),
ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2)
FROM superstore GROUP BY category;

--Q10  Top 5 Customers by Sales AND Profit
SELECT customer_name,SUM(sales)AS Total_sale,SUM(profit)
FROM superstore GROUP BY customer_name
ORDER BY Total_sale DESC
LIMIT 5;

--Q1. Top 5 Products by Quantity Sold
SELECT product_name,SUM(quantity)AS Total_pro
FROM superstore GROUP BY product_name
ORDER BY Total_pro DESC LIMIT 5;

--Q2. Top 10 Customers by Number of Orders

SELECT customer_name,COUNT(DISTINCT order_id)AS Total_order
FROM superstore GROUP BY customer_name
ORDER BY Total_order DESC LIMIT 10;

--Q3. Category-wise Average Profit
SELECT category,ROUND(AVG(profit),2) AS AVG_profit
FROM superstore GROUP BY category

--Q4. Top 5 Most Profitable Cities
SELECT city,SUM(profit) AS Total_profit
FROM superstore GROUP BY city
ORDER BY Total_profit DESC LIMIT 5;

--Q5. Top 5 Loss-Making States
SELECT state,SUM(profit) as Total_profit
FROM superstore GROUP BY state 
ORDER BY Total_profit ASC LIMIT 5;

--Q6. Which Ship Mode generated the highest Profit?
SELECT ship_mode,SUM(profit)as profit FROM superstore
GROUP BY ship_mode ORDER BY profit DESC LIMIT 1;

--Q7. Category-wise Total Orders
SELECT category,COUNT(DISTINCT order_id)
FROM superstore GROUP BY category

--Q8. Find all products whose total sales are greater than 10000
SELECT product_name,SUM(sales)AS Total_sale
FROM superstore GROUP BY product_name
HAVING SUM(sales)>10000;

--Q9. Top 3 Products in each Category

WITH product_sales AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rank_no
    FROM superstore
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    total_sales
FROM product_sales
WHERE rank_no <= 3
ORDER BY category, rank_no;

--Q10. Find Customers Whose Total Purchase is Greater than Average Purchase of All Customers
WITH customer_sales AS (
    SELECT
        customer_name,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY customer_name
)

SELECT
    customer_name,
    total_sales
FROM customer_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
)
ORDER BY total_sales DESC;


--Q1. Top 5 Customers by Average Order Value

SELECT 
    customer_name,
    SUM(sales) AS Total_sale,
    COUNT(order_id) AS Total_order,
    SUM(sales) / COUNT(DISTINCT order_id) AS Average_order
FROM 
    superstore
GROUP BY 
    customer_name
ORDER BY 
    Average_order DESC LIMIT 5;

--Q2. Find Customers Who Purchased from More Than 2 Categories

SELECT
    customer_name,
    COUNT(DISTINCT category) AS total_categories
FROM superstore
GROUP BY customer_name
HAVING COUNT(DISTINCT category) > 2;

--Q3. Find Products Sold in More Than 20 Orders
SELECT
    product_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name
HAVING COUNT(DISTINCT order_id) > 20;

--Q4. Which State Has the Highest Average Profit?
SELECT state,ROUND(AVG(profit),2)AS Average_profit FROM superstore
GROUP BY state
ORDER BY Average_profit DESC;

--Q5. Top 3 Cities by Number of Customers
SELECT city,COUNT(DISTINCT customer_id)AS Total_cus
FROM superstore GROUP BY city
ORDER BY Total_cus DESC LIMIT 3;

--Q6. Find Customers Who Never Made a Loss
SELECT
    customer_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_name
HAVING SUM(profit) > 0;

--Q7. Category-wise Profit Percentage
SELECT
    category,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100 /
        (SELECT SUM(profit) FROM superstore),
        2
    ) AS profit_percentage
FROM superstore
GROUP BY category;

--Q9. Find Products Whose Total Profit is Negative
SELECT
    product_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0;


--"Mujhe un customers ki list chahiye jinhone 10 se zyada orders place kiye hain."
SELECT customer_name,COUNT(DISTINCT order_id) AS Total_order
FROM superstore
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) >10;


--"Har category me kitne unique customers ne purchase kiya?"
SELECT category,COUNT(DISTINCT customer_name) 
FROM superstore GROUP BY category;

--"Mujhe sirf un states ki list chahiye jahan total sales 1,00,000 se zyada hai."
SELECT state,SUM(sales)AS Total_sale FROM superstore
GROUP BY state
HAVING SUM(sales)>100000;

--"Mujhe un products ki list chahiye jo 50 se zyada different customers ne kharide hain."
SELECT product_name, COUNT(DISTINCT customer_name) AS Customer 
FROM superstore 
GROUP BY product_name 
HAVING COUNT(DISTINCT customer_name) > 50;

--"Har state me kitne unique products bike?"
SELECT state,COUNT(DISTINCT product_name)
FROM superstore GROUP BY state;

--"Mujhe top 5 customers chahiye jinhone sabse zyada quantity purchase ki hai."
SELECT customer_name,
       SUM(quantity) AS total_quantity
FROM superstore
GROUP BY customer_name
ORDER BY total_quantity DESC
LIMIT 5;

--"Har ship mode ki average delivery sale batao."
SELECT ship_mode,AVG(sales) as Average
FROM superstore GROUP BY ship_mode

--"Mujhe un products ki list chahiye jinki average sale ₹500 se zyada hai."
SELECT product_name,ROUND(AVG(sales),2)AS Average
FROM superstore GROUP BY product_name
HAVING AVG(sales)>500;

--Q1. Products whose total sales are above the average sales of all products

--Q1. Products whose total sales are above the average sales of all products
WITH productSale AS (
    SELECT 
        product_name,
        SUM(sales) AS Total_Sale
    FROM superstore 
    GROUP BY product_name
)
SELECT 
    product_name, 
    Total_Sale
FROM productSale
WHERE Total_Sale > (SELECT AVG(Total_Sale) FROM productSale)
ORDER BY Total_Sale DESC;

--Q2. Customers whose total profit is below the average customer profit
WITH customer AS(
SELECT customer_name,SUM(profit) AS Total_profit
FROM superstore GROUP BY customer_name
)
SELECT customer_name,Total_profit FROM customer
WHERE Total_profit<(SELECT AVG(Total_profit) FROM customer)
ORDER BY Total_profit ASC;

--Q3. Top 2 Products in Every Category
WITH RankedProduct AS(
SELECT category,product_name,SUM(sales)AS Total_sale,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(Sales)DESC)AS product_rank
FROM superstore
GROUP BY category,product_name
)
SELECT category,product_name,Total_sale
FROM RankedProduct
WHERE product_rank<=2
ORDER BY category ASC,product_rank ASC;

--Q4. Find the Second Highest Sales Product
SELECT product_name,SUM(sales) AS Total_sale
FROM superstore
GROUP BY product_name
ORDER BY Total_sale DESC
LIMIT 1 OFFSET 1;

--Q5. Find the Second Highest Profit Customer
SELECT customer_name,SUM(profit) AS Total_profit
FROM superstore
GROUP BY customer_name
ORDER BY Total_profit DESC
LIMIT 1 OFFSET 1;

--Q6. State-wise Ranking Based on Sales
SELECT state,SUM(sales) AS Total_sale,
RANK()OVER(ORDER BY SUM(sales)DESC)AS state_Rank
FROM superstore
GROUP BY state
ORDER BY state_Rank;

--Q7. Running Total of Sales
SELECT order_date,order_id,sales,
SUM(sales) OVER(ORDER BY order_date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
AS Running_Total
FROM superstore
ORDER BY order_date ASC;

--Q8. Monthly Sales Trend
SELECT
    EXTRACT(YEAR FROM TO_DATE(order_date,'MM/DD/YYYY')) AS year,
    EXTRACT(MONTH FROM TO_DATE(order_date,'MM/DD/YYYY')) AS month,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY
    EXTRACT(YEAR FROM TO_DATE(order_date,'MM/DD/YYYY')),
    EXTRACT(MONTH FROM TO_DATE(order_date,'MM/DD/YYYY'))
ORDER BY year, month;

--Q9. Find Customers Who Purchased in All Regions
SELECT customer_name,COUNT(DISTINCT region)as Region
FROM superstore
GROUP BY customer_name
HAVING COUNT(DISTINCT region)=(SELECT COUNT(DISTINCT region)FROM superstore)
ORDER BY customer_name ASC;

--Q10. Top 5 Most Frequently Ordered Products
SELECT
    product_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name
ORDER BY total_orders DESC
LIMIT 5;






