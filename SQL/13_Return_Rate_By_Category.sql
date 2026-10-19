
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Approved return rate by product category
-- Dataset: Synthetic retail data created for analytics practice.
-- Note: This is a period-level rate, not an order-level cohort rate.

WITH SalesByCategory AS
(
    SELECT
        p.Category,
        SUM(fs.Quantity) AS UnitsSold
    FROM dbo.FactSales AS fs
    INNER JOIN dbo.DimProduct AS p
        ON fs.ProductKey = p.ProductKey
    WHERE fs.OrderStatus = 'Completed'
    GROUP BY p.Category
),
ReturnsByCategory AS
(
    SELECT
        p.Category,
        SUM(r.ReturnQuantity) AS ApprovedReturnedUnits,
        SUM(r.RefundAmount) AS ApprovedRefundAmount,
        COUNT_BIG(*) AS ApprovedReturnRecords
    FROM dbo.FactReturns AS r
    INNER JOIN dbo.DimProduct AS p
        ON r.ProductKey = p.ProductKey
    WHERE r.ReturnStatus = 'Approved'
    GROUP BY p.Category
)
SELECT
    s.Category,
    s.UnitsSold,
    COALESCE(r.ApprovedReturnedUnits, 0) AS ApprovedReturnedUnits,
    COALESCE(r.ApprovedReturnRecords, 0) AS ApprovedReturnRecords,
    COALESCE(r.ApprovedRefundAmount, 0) AS ApprovedRefundAmount,
    CAST(
        100.0 * COALESCE(r.ApprovedReturnedUnits, 0)
        / NULLIF(s.UnitsSold, 0)
        AS DECIMAL(10, 2)
    ) AS PeriodReturnRatePct
FROM SalesByCategory AS s
LEFT JOIN ReturnsByCategory AS r
    ON s.Category = r.Category
ORDER BY PeriodReturnRatePct DESC;
GO
