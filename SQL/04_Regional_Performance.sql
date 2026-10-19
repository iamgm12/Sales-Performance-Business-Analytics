
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Regional sales and profitability
-- Dataset: Synthetic retail data created for analytics practice.

SELECT
    r.RegionName AS Region,
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.Quantity) AS UnitsSold,
    SUM(fs.SalesAmount) AS GrossSales,
    SUM(fs.DiscountAmount) AS TotalDiscount,
    SUM(fs.NetSalesAmount) AS NetSales,
    SUM(fs.TotalCost) AS TotalCost,
    SUM(fs.ProfitAmount) AS TotalProfit,
    CAST(
        100.0 * SUM(fs.ProfitAmount)
        / NULLIF(SUM(fs.NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimStore AS s
    ON fs.StoreKey = s.StoreKey
INNER JOIN dbo.DimRegion AS r
    ON s.RegionKey = r.RegionKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY r.RegionName
ORDER BY NetSales DESC;
GO
