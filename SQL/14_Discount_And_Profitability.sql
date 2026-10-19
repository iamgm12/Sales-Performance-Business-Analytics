
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Discount levels and profitability
-- Dataset: Synthetic retail data created for analytics practice.

WITH DiscountAnalysis AS
(
    SELECT
        CASE
            WHEN SalesAmount <= 0 THEN 'Invalid or zero gross sales'
            WHEN DiscountAmount = 0 THEN 'No discount'
            WHEN DiscountAmount / NULLIF(SalesAmount, 0) < 0.05
                THEN 'Under 5%'
            WHEN DiscountAmount / NULLIF(SalesAmount, 0) < 0.10
                THEN '5% to under 10%'
            WHEN DiscountAmount / NULLIF(SalesAmount, 0) < 0.20
                THEN '10% to under 20%'
            ELSE '20% or more'
        END AS DiscountBand,
        OrderID,
        Quantity,
        SalesAmount,
        DiscountAmount,
        NetSalesAmount,
        TotalCost,
        ProfitAmount
    FROM dbo.FactSales
    WHERE OrderStatus = 'Completed'
)
SELECT
    DiscountBand,
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    SUM(Quantity) AS UnitsSold,
    SUM(SalesAmount) AS GrossSales,
    SUM(DiscountAmount) AS TotalDiscount,
    SUM(NetSalesAmount) AS NetSales,
    SUM(TotalCost) AS TotalCost,
    SUM(ProfitAmount) AS TotalProfit,
    CAST(
        100.0 * SUM(DiscountAmount)
        / NULLIF(SUM(SalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS DiscountPctOfGrossSales,
    CAST(
        100.0 * SUM(ProfitAmount)
        / NULLIF(SUM(NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct
FROM DiscountAnalysis
GROUP BY DiscountBand
ORDER BY
    CASE DiscountBand
        WHEN 'No discount' THEN 1
        WHEN 'Under 5%' THEN 2
        WHEN '5% to under 10%' THEN 3
        WHEN '10% to under 20%' THEN 4
        WHEN '20% or more' THEN 5
        ELSE 6
    END;
GO
