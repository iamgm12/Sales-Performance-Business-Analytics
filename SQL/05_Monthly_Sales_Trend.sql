
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Sales channel performance
-- Dataset: Synthetic retail data created for analytics practice.

SELECT
    fs.Channel,
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
WHERE fs.OrderStatus = 'Completed'
GROUP BY fs.Channel
ORDER BY NetSales DESC;
GO
