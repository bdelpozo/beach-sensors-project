{{ config(materialized='table') }}

WITH generate_date AS (
    SELECT CAST(RANGE AS DATE) AS date_key
    FROM RANGE(DATE '2002-01-01', DATE '2022-12-31', INTERVAL 1 DAY)
)

SELECT 
    date_key AS id,
    date_key,
    YEAR(date_key) AS year,
    MONTH(date_key) AS month,
    DAY(date_key) AS day,
    QUARTER(date_key) AS quarter,
    DAYOFYEAR(date_key) AS day_of_year,
    YEARWEEK(date_key) AS week_key,
    WEEKOFYEAR(date_key) AS week_of_year,
    DAYOFWEEK(date_key) AS day_of_week,
    CASE 
        WHEN DAYOFWEEK(date_key) IN (1, 7) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS is_weekend,
    CASE 
        WHEN MONTH(date_key) = 1 THEN 'January'
        WHEN MONTH(date_key) = 2 THEN 'February'
        WHEN MONTH(date_key) = 3 THEN 'March'
        WHEN MONTH(date_key) = 4 THEN 'April'
        WHEN MONTH(date_key) = 5 THEN 'May'
        WHEN MONTH(date_key) = 6 THEN 'June'
        WHEN MONTH(date_key) = 7 THEN 'July'
        WHEN MONTH(date_key) = 8 THEN 'August'
        WHEN MONTH(date_key) = 9 THEN 'September'
        WHEN MONTH(date_key) = 10 THEN 'October'
        WHEN MONTH(date_key) = 11 THEN 'November'
        WHEN MONTH(date_key) = 12 THEN 'December'
    END AS month_name,
    CASE 
        WHEN QUARTER(date_key) = 1 THEN 'Q1'
        WHEN QUARTER(date_key) = 2 THEN 'Q2'
        WHEN QUARTER(date_key) = 3 THEN 'Q3'
        WHEN QUARTER(date_key) = 4 THEN 'Q4'
    END AS quarter_name,
    STRFTIME(date_key, '%A') AS day_name,
    STRFTIME(date_key, '%B') AS full_month_name,
    STRFTIME(date_key, '%a') AS short_day_name,
    STRFTIME(date_key, '%b') AS short_month_name
FROM generate_date
ORDER BY date_key