{{ config(materialized='table') }}

WITH avg_data AS (
    SELECT 
        AVG(humidity) AS avg_humidity,
        AVG(solar_radiation) AS avg_solar_radiation,
        dim_time.part_of_day AS part_of_day,
        month_e
    FROM dbt_blue.fact_sensors_data
        LEFT JOIN dbt_blue.dim_time ON hour_e = dim_time.hour
      WHERE month_e NOT IN (12,1,2)
        AND part_of_day <> 'Night' 
    GROUP BY month_e, part_of_day
    ORDER BY month_e ASC, part_of_day
      )
SELECT 
    part_of_day,
    month_e,
    avg_humidity,
    avg_solar_radiation,
    LAG(avg_humidity) OVER (PARTITION BY part_of_day ORDER BY month_e) AS prev_avg_humidity,
    LAG(avg_solar_radiation) OVER (PARTITION BY part_of_day ORDER BY month_e) AS prev_avg_solar_radiation,
    (avg_humidity - LAG(avg_humidity) OVER (PARTITION BY part_of_day ORDER BY month_e)) AS diff_avg_humidity,
    (avg_solar_radiation - LAG(avg_solar_radiation) OVER (PARTITION BY part_of_day ORDER BY month_e)) AS diff_avg_solar_radiation
FROM avg_data
ORDER BY part_of_day, month_e
