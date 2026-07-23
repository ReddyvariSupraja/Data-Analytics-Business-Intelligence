create database task3;

select * from orders;

select * from customers;

-- Step 1: Monthly Performance Analysis
SELECT 
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales,
    ROUND(SUM(Profit), 2) AS Monthly_Profit,
    ROUND((SUM(Profit) / NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin_Pct
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Order_Year ASC, Order_Month ASC;   


UPDATE Orders 
SET Order_Date = STR_TO_DATE(Order_Date, '%Y-%m-%d');

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE Orders 
MODIFY COLUMN Order_Date DATE;

SET SQL_SAFE_UPDATES = 0;


UPDATE Orders 
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y');


ALTER TABLE Orders 
MODIFY COLUMN Order_Date DATE;

SET SQL_SAFE_UPDATES = 1;

-- Step 2: Growth Rate Calculation (Month-over-Month Variance)
SELECT 
    t1.Order_Year,
    t1.Order_Month,
    t1.Monthly_Sales AS Current_Month_Sales,
    t2.Monthly_Sales AS Previous_Month_Sales,
    ROUND(t1.Monthly_Sales - t2.Monthly_Sales, 2) AS Sales_Variance,
    ROUND(((t1.Monthly_Sales - t2.Monthly_Sales) / NULLIF(t2.Monthly_Sales, 0)) * 100, 2) AS Growth_Percentage
FROM (
    SELECT 
        YEAR(Order_Date) AS Order_Year,
        MONTH(Order_Date) AS Order_Month,
        SUM(Sales) AS Monthly_Sales
    FROM Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
) t1
LEFT JOIN (
    SELECT 
        YEAR(Order_Date) AS Order_Year,
        MONTH(Order_Date) AS Order_Month,
        SUM(Sales) AS Monthly_Sales
    FROM Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
) t2 
    ON (t1.Order_Year = t2.Order_Year AND t1.Order_Month = t2.Order_Month + 1)
    OR (t1.Order_Year = t2.Order_Year + 1 AND t1.Order_Month = 1 AND t2.Order_Month = 12)
ORDER BY t1.Order_Year, t1.Order_Month;

-- Step 3: Business Classification Using CASE Statement
SELECT 
    Order_ID,
    Customer_ID,
    Category,
    ROUND(Sales, 2) AS Order_Sales,
    ROUND(Profit, 2) AS Order_Profit,
    CASE 
        WHEN Sales > 1000 THEN 'High Value'
        WHEN Sales BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Type
FROM Orders
ORDER BY Sales DESC;

-- Step 4: Identify Underperforming Regions Using HAVING Clause
SELECT 
    c.Region,
    ROUND(SUM(o.Sales), 2) AS Total_Sales,
    ROUND(SUM(o.Profit), 2) AS Total_Profit,
    ROUND((SUM(o.Profit) / NULLIF(SUM(o.Sales), 0)) * 100, 2) AS Profit_Margin_Pct
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
HAVING SUM(o.Profit) < 10000
ORDER BY Total_Profit ASC;

