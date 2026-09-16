-- ============================================================
-- CUSTOMER & REVENUE ANALYTICS
-- SQL Analysis
-- Tools: SQL, Excel, Power BI
-- ============================================================


-- ============================================================
-- 1. TOTAL REVENUE
-- ============================================================

SELECT
    SUM(Revenue) AS total_revenue
FROM sales_data;


-- ============================================================
-- 2. TOTAL ORDERS
-- ============================================================

SELECT
    COUNT(DISTINCT Order_ID) AS total_orders
FROM sales_data;


-- ============================================================
-- 3. TOTAL UNITS SOLD
-- ============================================================

SELECT
    SUM(Quantity) AS total_units_sold
FROM sales_data;


-- ============================================================
-- 4. REVENUE BY REGION
-- ============================================================

SELECT
    Region,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Region
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. REVENUE BY CATEGORY
-- ============================================================

SELECT
    Category,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Category
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. TOP 10 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    Customer_Name,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Customer_Name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 7. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    Product_Name,
    SUM(Revenue) AS total_revenue
FROM sales_data
GROUP BY Product_Name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 8. CUSTOMER REVENUE USING A CTE
-- Shows customers whose total revenue is above ₹500,000
-- ============================================================

WITH customer_totals AS (
    SELECT
        Customer_Name,
        SUM(Revenue) AS total_revenue
    FROM sales_data
    GROUP BY Customer_Name
)
SELECT
    Customer_Name,
    total_revenue
FROM customer_totals
WHERE total_revenue > 500000
ORDER BY total_revenue DESC;


-- ============================================================
-- 9. CUSTOMERS ABOVE THE AVERAGE CUSTOMER REVENUE
-- CTE + subquery
-- ============================================================

WITH customer_totals AS (
    SELECT
        Customer_Name,
        SUM(Revenue) AS total_revenue
    FROM sales_data
    GROUP BY Customer_Name
)
SELECT
    Customer_Name,
    total_revenue
FROM customer_totals
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM customer_totals
)
ORDER BY total_revenue DESC;


-- ============================================================
-- 10. CUSTOMERS WITH AN ORDER ABOVE THE AVERAGE ORDER VALUE
-- Scalar subquery
-- ============================================================

SELECT
    Customer_Name,
    Order_ID,
    Revenue
FROM sales_data
WHERE Revenue > (
    SELECT AVG(Revenue)
    FROM sales_data
)
ORDER BY Revenue DESC;


-- ============================================================
-- 11. HIGHEST-REVENUE ORDER(S)
-- MAX() subquery
-- Handles ties
-- ============================================================

SELECT
    Order_ID,
    Customer_Name,
    Revenue
FROM sales_data
WHERE Revenue = (
    SELECT MAX(Revenue)
    FROM sales_data
);


-- ============================================================
-- 12. LOWEST-REVENUE ORDER(S)
-- MIN() subquery
-- ============================================================

SELECT
    Order_ID,
    Customer_Name,
    Revenue
FROM sales_data
WHERE Revenue = (
    SELECT MIN(Revenue)
    FROM sales_data
);


-- ============================================================
-- 13. PRODUCTS RANKED WITHIN EACH CATEGORY
-- DENSE_RANK() window function
-- ============================================================

SELECT
    Product_Name,
    Category,
    SUM(Revenue) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY Category
        ORDER BY SUM(Revenue) DESC
    ) AS category_rank
FROM sales_data
GROUP BY Product_Name, Category
ORDER BY Category, category_rank;


-- ============================================================
-- 14. TOP 3 PRODUCTS WITHIN EACH CATEGORY
-- ROW_NUMBER() + CTE
-- ============================================================

WITH product_rankings AS (
    SELECT
        Product_Name,
        Category,
        SUM(Revenue) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Category
            ORDER BY SUM(Revenue) DESC
        ) AS row_num
    FROM sales_data
    GROUP BY Product_Name, Category
)
SELECT
    Product_Name,
    Category,
    total_revenue
FROM product_rankings
WHERE row_num <= 3
ORDER BY Category, total_revenue DESC;


-- ============================================================
-- 15. CUSTOMER REVENUE RANK
-- RANK() window function
-- ============================================================

WITH customer_totals AS (
    SELECT
        Customer_Name,
        SUM(Revenue) AS total_revenue
    FROM sales_data
    GROUP BY Customer_Name
)
SELECT
    Customer_Name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_totals
ORDER BY revenue_rank;


-- ============================================================
-- 16. CUSTOMER ORDER SEQUENCE
-- ROW_NUMBER() within each customer
-- ============================================================

SELECT
    Order_ID,
    Customer_Name,
    Order_Date,
    Revenue,
    ROW_NUMBER() OVER (
        PARTITION BY Customer_Name
        ORDER BY Order_Date
    ) AS order_sequence
FROM sales_data
ORDER BY Customer_Name, order_sequence;
