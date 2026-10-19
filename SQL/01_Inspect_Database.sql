USE NexaMartAnalytics;
GO

-- Project: Sales Performance & Business Analytics Dashboard
-- Purpose: Inspect the database tables for portfolio documentation.
-- Dataset: Synthetic retail data created for analytics practice.

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO
