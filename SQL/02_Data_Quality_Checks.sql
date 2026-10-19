
USE NexaMartAnalytics;
GO

-- 1. Row counts
SELECT 'FactSales' AS TableName, COUNT_BIG(*) AS TotalRows
FROM dbo.FactSales
UNION ALL
SELECT 'FactReturns', COUNT_BIG(*)
FROM dbo.FactReturns;

-- 2. Sales date-key range
SELECT
    MIN(OrderDateKey) AS FirstOrderDateKey,
    MAX(OrderDateKey) AS LastOrderDateKey,
    COUNT_BIG(*) AS SalesLines
FROM dbo.FactSales;

-- 3. Missing sales dimension keys
SELECT
    SUM(CASE WHEN OrderDateKey IS NULL THEN 1 ELSE 0 END) AS MissingOrderDateKey,
    SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS MissingProductKey,
    SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS MissingCustomerKey,
    SUM(CASE WHEN StoreKey IS NULL THEN 1 ELSE 0 END) AS MissingStoreKey
FROM dbo.FactSales;

-- 4. Sales status distribution
SELECT
    OrderStatus,
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT OrderID) AS DistinctOrders
FROM dbo.FactSales
GROUP BY OrderStatus
ORDER BY SalesLines DESC;

-- 5. Return status distribution
SELECT
    ReturnStatus,
    COUNT_BIG(*) AS ReturnRecords,
    SUM(ReturnQuantity) AS ReturnedUnits,
    SUM(RefundAmount) AS RefundAmount
FROM dbo.FactReturns
GROUP BY ReturnStatus
ORDER BY ReturnRecords DESC;
GO
