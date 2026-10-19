
USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Analysis: Final business KPI summary
-- Dataset: Synthetic retail data created for analytics practice.
-- Note: Sales and returns are reported separately because
-- they are recorded using different business events and dates.

-- 1. Overall completed-sales KPIs
SELECT
    COUNT_BIG(*) AS CompletedSalesLines,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerKey) AS CustomersWithCompletedSales,
    COUNT(DISTINCT StoreKey) AS ActiveStores,
    SUM(Quantity) AS UnitsSold,
    SUM(SalesAmount) AS GrossSales,
    SUM(DiscountAmount) AS TotalDiscount,
    SUM(NetSalesAmount) AS NetSales,
    SUM(TotalCost) AS TotalCost,
    SUM(ProfitAmount) AS TotalProfit,
    CAST(
        100.0 * SUM(ProfitAmount)
        / NULLIF(SUM(NetSalesAmount), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct,
    CAST(
        SUM(NetSalesAmount)
        / NULLIF(COUNT(DISTINCT OrderID), 0)
        AS DECIMAL(18, 2)
    ) AS AverageOrderValue,
    CAST(
        SUM(NetSalesAmount)
        / NULLIF(SUM(Quantity), 0)
        AS DECIMAL(18, 2)
    ) AS AverageNetSalesPerUnit
FROM dbo.FactSales
WHERE OrderStatus = 'Completed';
GO

-- 2. Sales status breakdown
SELECT
    OrderStatus,
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT OrderID) AS DistinctOrders,
    SUM(Quantity) AS Units
FROM dbo.FactSales
GROUP BY OrderStatus
ORDER BY SalesLines DESC;
GO

-- 3. Returns and refunds by status
SELECT
    ReturnStatus,
    COUNT_BIG(*) AS ReturnRecords,
    SUM(ReturnQuantity) AS ReturnedUnits,
    SUM(RefundAmount) AS RefundAmount,
    CAST(
        AVG(CAST(RefundAmount AS DECIMAL(18, 2)))
        AS DECIMAL(18, 2)
    ) AS AverageRefundPerRecord
FROM dbo.FactReturns
GROUP BY ReturnStatus
ORDER BY ReturnRecords DESC;
GO

-- 4. Overall return and refund totals
SELECT
    COUNT_BIG(*) AS TotalReturnRecords,
    SUM(ReturnQuantity) AS TotalReturnedUnits,
    SUM(RefundAmount) AS TotalRefundAmount,
    SUM(CASE WHEN ReturnStatus = 'Approved'
        THEN 1 ELSE 0 END) AS ApprovedReturnRecords,
    SUM(CASE WHEN ReturnStatus = 'Pending'
        THEN 1 ELSE 0 END) AS PendingReturnRecords,
    SUM(CASE WHEN ReturnStatus = 'Rejected'
        THEN 1 ELSE 0 END) AS RejectedReturnRecords
FROM dbo.FactReturns;
GO
