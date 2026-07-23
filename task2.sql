Use task3;

-- 1. Perform INNER JOIN

SELECT 
    o.Order_ID, 
    o.Order_Date, 
    c.Customer_Name, 
    c.Region, 
    o.Category, 
    o.Sales, 
    o.Profit
FROM Orders o
INNER JOIN Customers c 
    ON o.Customer_ID = c.Customer_ID;
    
-- 2. Total Sales by Region

SELECT 
    c.Region, 
    SUM(o.Sales) AS Total_Sales
FROM Orders o
JOIN Customers c 
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Sales DESC;

-- 3. Profit Margin by Category

SELECT 
    Category, 
    SUM(Profit)/SUM(Sales) AS Profit_Margin
FROM Orders
GROUP BY Category
ORDER BY Profit_Margin DESC;

-- 4. Monthly Sales Trend

SELECT 
    MONTH(Order_Date) AS Month, 
    SUM(Sales) AS Monthly_Sales
FROM Orders
GROUP BY Month
ORDER BY Month;

-- 5. Top 5 Customers by Revenue
SELECT 
    c.Customer_Name, 
    SUM(o.Sales) AS Total_Revenue
FROM Orders o
JOIN Customers c 
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 5;

