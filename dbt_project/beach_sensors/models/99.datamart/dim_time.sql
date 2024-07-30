{{ config(materialized='table')}}

WITH TimeSeries AS (
    SELECT 
        r.datetime_value::TIME AS ID,
        EXTRACT(HOUR FROM r.datetime_value) AS hour,
        EXTRACT(MINUTE FROM r.datetime_value) AS minute,
        EXTRACT(SECOND FROM r.datetime_value) AS second,
        CASE
            WHEN EXTRACT(HOUR FROM r.datetime_value) BETWEEN 21 AND 6 THEN 'Night'
            WHEN EXTRACT(HOUR FROM r.datetime_value) BETWEEN 6 AND 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM r.datetime_value) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN EXTRACT(HOUR FROM r.datetime_value) BETWEEN 17 AND 21 THEN 'Evening'
        END AS part_of_day
    FROM RANGE(TIMESTAMP '2022-01-01 00:00:00', TIMESTAMP '2022-01-01 23:59:00', INTERVAL 1 HOUR) AS r(datetime_value)
)

SELECT * FROM TimeSeries