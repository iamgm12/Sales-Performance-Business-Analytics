
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Store sales and profitability performance
-- Dataset: Synthetic retail data created for analytics practice.
-- Note: Only completed sales are included.

-- 1. Overall store performance summary
SELECT
    COUNT(DISTINCT fs.StoreKey) AS ActiveStores,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.Quantity) AS UnitsSold,
    SUM(fs.NetSalesAmount) AS TotalNetSales,
    SUM(fs.ProfitAmount) AS TotalProfit,
    CAST(
        SUM(fs.ProfitAmount) * 100.0
        / NULLIF(SUM(fs.NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct
FROM dbo.FactSales AS fs
WHERE fs.OrderStatus = 'Completed';
GO

-- 2. Store performance ranking
SELECT
    s.StoreKey,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    COUNT_BIG(*) AS SalesLines,
    SUM(fs.Quantity) AS UnitsSold,
    SUM(fs.SalesAmount) AS GrossSales,
    SUM(fs.DiscountAmount) AS TotalDiscount,
    SUM(fs.NetSalesAmount) AS TotalNetSales,
    SUM(fs.TotalCost) AS TotalCost,
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
INNER JOIN dbo.DimStore AS s
    ON fs.StoreKey = s.StoreKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY s.StoreKey
ORDER BY TotalNetSales DESC;
GO

-- 3. Top 10 stores by profit
SELECT TOP (10)
    s.StoreKey,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.Quantity) AS UnitsSold,
    SUM(fs.NetSalesAmount) AS TotalNetSales,
    SUM(fs.ProfitAmount) AS TotalProfit,
    CAST(
        SUM(fs.ProfitAmount) * 100.0
        / NULLIF(SUM(fs.NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimStore AS s
    ON fs.StoreKey = s.StoreKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY s.StoreKey
ORDER BY TotalProfit DESC;
GO
