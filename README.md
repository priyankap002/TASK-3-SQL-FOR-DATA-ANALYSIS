# Task 3: SQL for Data Analysis

## Objective
Use SQL in MySQL to extract and analyze e-commerce data.

## Files
- `Task3_SQL_Data_Analysis.sql` — complete MySQL 8.0+ script (database, tables, sample data, queries, view and indexes).
- `Output_Preview_1.png` to `Output_Preview_3.png` — illustrative output previews based on the included sample data. These are not screenshots captured from MySQL Workbench.

## How to run in MySQL Workbench
1. Open MySQL Workbench and connect to your MySQL server.
2. Open `Task3_SQL_Data_Analysis.sql`.
3. Click the lightning-bolt **Execute** button to run the full script.
4. Run individual SELECT queries again if you want to capture separate result grids.
5. For real submission screenshots, capture the query and its Result Grid using `Win + Shift + S` and save the images in this folder.

## Concepts covered
- `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`
- Subqueries using `AVG` and `IN`
- Aggregate functions: `SUM`, `AVG`, `COUNT`
- `CREATE OR REPLACE VIEW`
- Indexes using `CREATE INDEX` and query plan inspection using `EXPLAIN`

## Notes
- Currency values are sample Indian Rupee amounts (₹).
- The script is designed for MySQL 8.0+.
- The RIGHT JOIN query includes all products, even products without matching order items.
- Indexes are created on frequently filtered/joined columns. On a very small sample dataset, performance improvement may not be measurable; use `EXPLAIN` to inspect the plan.
