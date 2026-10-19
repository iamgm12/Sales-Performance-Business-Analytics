
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Sales and profitability by product category
-- Dataset: Synthetic retail data created for analytics practice.

SELECT
    p.Category,
    COUNT_BIG(*) AS SalesLines,
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
INNER JOIN dbo.DimProduct AS p
    ON fs.ProductKey = p.ProductKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY p.Category
ORDER BY NetSales DESC;
GO
