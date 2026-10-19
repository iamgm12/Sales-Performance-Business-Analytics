
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Customer performance and value
-- Dataset: Synthetic retail data created for analytics practice.

-- 1. Overall customer performance
SELECT
    COUNT(DISTINCT fs.CustomerKey) AS ActiveCustomers,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.Quantity) AS UnitsSold,
    SUM(fs.NetSalesAmount) AS TotalNetSales,
    SUM(fs.ProfitAmount) AS TotalProfit,
    CAST(
        SUM(fs.NetSalesAmount) / NULLIF(COUNT(DISTINCT fs.OrderID), 0)
        AS DECIMAL(18, 2)
    ) AS AverageOrderValue
FROM dbo.FactSales AS fs
WHERE fs.OrderStatus = 'Completed';
GO

-- 2. Top 20 customers by net sales
SELECT TOP (20)
    c.CustomerKey,
    c.CustomerID,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.Quantity) AS UnitsPurchased,
    SUM(fs.NetSalesAmount) AS TotalNetSales,
    SUM(fs.ProfitAmount) AS TotalProfit,
    CAST(
        SUM(fs.ProfitAmount) * 100.0
        / NULLIF(SUM(fs.NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct,
    CAST(
        SUM(fs.NetSalesAmount)
        / NULLIF(COUNT(DISTINCT fs.OrderID), 0)
        AS DECIMAL(18, 2)
    ) AS AverageOrderValue
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimCustomer AS c
    ON fs.CustomerKey = c.CustomerKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY
    c.CustomerKey,
    c.CustomerID
ORDER BY
    TotalNetSales DESC;
GO

-- 3. Customer sales and profit segments
WITH CustomerPerformance AS
(
    SELECT
        fs.CustomerKey,
        SUM(fs.NetSalesAmount) AS TotalNetSales,
        SUM(fs.ProfitAmount) AS TotalProfit,
        COUNT(DISTINCT fs.OrderID) AS TotalOrders
    FROM dbo.FactSales AS fs
    WHERE fs.OrderStatus = 'Completed'
    GROUP BY fs.CustomerKey
)
SELECT
    CASE
        WHEN TotalNetSales >= 10000 THEN 'High Value'
        WHEN TotalNetSales >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerSegment,
    COUNT(*) AS CustomerCount,
    SUM(TotalNetSales) AS TotalNetSales,
    SUM(TotalProfit) AS TotalProfit,
    CAST(AVG(TotalNetSales) AS DECIMAL(18, 2))
        AS AverageSalesPerCustomer,
    CAST(AVG(TotalOrders * 1.0) AS DECIMAL(10, 2))
        AS AverageOrdersPerCustomer
FROM CustomerPerformance
GROUP BY
    CASE
        WHEN TotalNetSales >= 10000 THEN 'High Value'
        WHEN TotalNetSales >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END
ORDER BY
    TotalNetSales DESC;
GO
