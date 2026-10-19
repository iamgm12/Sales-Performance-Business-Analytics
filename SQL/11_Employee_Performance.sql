
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Employee sales and profitability performance
-- Dataset: Synthetic retail data created for analytics practice.
-- Note: Only completed sales are included.

-- 1. Overall employee performance summary
SELECT
    COUNT(DISTINCT fs.EmployeeKey) AS ActiveEmployees,
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

-- 2. Employee performance ranking
SELECT
    e.EmployeeKey,
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
INNER JOIN dbo.DimEmployee AS e
    ON fs.EmployeeKey = e.EmployeeKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY e.EmployeeKey
ORDER BY TotalNetSales DESC;
GO

-- 3. Top 10 employees by profit
SELECT TOP (10)
    e.EmployeeKey,
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
INNER JOIN dbo.DimEmployee AS e
    ON fs.EmployeeKey = e.EmployeeKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY e.EmployeeKey
ORDER BY TotalProfit DESC;
GO
