-- Customer & Revenue Analytics
-- SQL analysis used for project insights


-- 1. Total Revenue
SELECT
    SUM(Revenue) AS total_revenue
FROM sales_data;


-- 2. Total Orders
SELECT
    COUNT(DISTINCT Order_ID) AS total_orders
FROM sales_data;


-- 3. Total Units Sold
SELECT
    SUM(Quantity) AS total_units_sold
FROM sales_data;


-- 4. Revenue by Region
SELECT
    Region,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Region
ORDER BY total_revenue DESC;


-- 5. Revenue by Category
SELECT
    Category,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Category
ORDER BY total_revenue DESC;


-- 6. Top 10 Customers by Revenue
SELECT
    Customer_Name,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Customer_Name
ORDER BY total_revenue DESC
LIMIT 10;


-- 7. Top 10 Products by Revenue
SELECT
    Product_Name,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Product_Name
ORDER BY total_revenue DESC
LIMIT 10;


-- 8. Monthly Revenue
SELECT
    EXTRACT(MONTH FROM Order_Date) AS order_month,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY EXTRACT(MONTH FROM Order_Date)
ORDER BY order_month;
