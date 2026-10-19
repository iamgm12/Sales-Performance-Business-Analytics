
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Returns and refund performance
-- Dataset: Synthetic retail data created for analytics practice.

-- 1. Return performance by status
SELECT
    ReturnStatus,
    COUNT_BIG(*) AS TotalReturnRecords,
    SUM(ReturnQuantity) AS TotalReturnedUnits,
    SUM(RefundAmount) AS TotalRefundAmount,
    CAST(
        AVG(CAST(RefundAmount AS DECIMAL(18, 2)))
        AS DECIMAL(18, 2)
    ) AS AverageRefundPerRecord
FROM dbo.FactReturns
GROUP BY ReturnStatus
ORDER BY TotalReturnRecords DESC;
GO

-- 2. Overall returns summary
SELECT
    COUNT_BIG(*) AS TotalReturnRecords,
    SUM(ReturnQuantity) AS TotalReturnedUnits,
    SUM(RefundAmount) AS TotalRefundAmount,
    SUM(CASE WHEN ReturnStatus = 'Approved' THEN 1 ELSE 0 END)
        AS ApprovedReturnRecords,
    SUM(CASE WHEN ReturnStatus = 'Pending' THEN 1 ELSE 0 END)
        AS PendingReturnRecords,
    SUM(CASE WHEN ReturnStatus = 'Rejected' THEN 1 ELSE 0 END)
        AS RejectedReturnRecords
FROM dbo.FactReturns;
GO

-- 3. Return records by return date
SELECT
    d.YearNumber AS [Year],
    d.MonthNumber,
    d.MonthName,
    r.ReturnStatus,
    COUNT_BIG(*) AS TotalReturnRecords,
    SUM(r.ReturnQuantity) AS TotalReturnedUnits,
    SUM(r.RefundAmount) AS TotalRefundAmount
FROM dbo.FactReturns AS r
INNER JOIN dbo.DimDate AS d
    ON r.ReturnDateKey = d.DateKey
GROUP BY
    d.YearNumber,
    d.MonthNumber,
    d.MonthName,
    r.ReturnStatus
ORDER BY
    d.YearNumber,
    d.MonthNumber,
    r.ReturnStatus;
GO
