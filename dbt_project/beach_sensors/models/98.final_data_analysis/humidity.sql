{{ config(materialized='table') }}

SELECT
    station_name,
    measurement_timestamp,
    humidity,
    CASE 
        WHEN humidity BETWEEN 0 AND 30 THEN 'Low'
        WHEN humidity BETWEEN 30 AND 50 THEN 'Moderate'
        WHEN humidity BETWEEN 50 AND 70 THEN 'High'
        ELSE 'Very high'
    END AS humidity_level,
    hour_e,   
    day_e,
    month_e,
    year_e,
    sensor_latitude,
    sensor_longitude
FROM dbt_blue.fact_sensors_data 
ORDER BY humidity DESC