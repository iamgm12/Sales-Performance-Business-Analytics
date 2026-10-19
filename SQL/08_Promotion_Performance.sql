
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Promotion performance and profitability
-- Dataset: Synthetic retail data created for analytics practice.

SELECT
    COALESCE(p.PromotionName, 'No Promotion') AS PromotionName,
    p.PromotionType,
    p.DiscountPercent,
    p.PromotionStatus,
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
LEFT JOIN dbo.DimPromotion AS p
    ON fs.PromotionKey = p.PromotionKey
WHERE fs.OrderStatus = 'Completed'
GROUP BY
    p.PromotionName,
    p.PromotionType,
    p.DiscountPercent,
    p.PromotionStatus
ORDER BY
    TotalProfit DESC;
GO
