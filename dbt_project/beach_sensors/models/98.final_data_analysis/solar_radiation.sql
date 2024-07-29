{{ config(materialized='table') }}

SELECT 
    station_name,
    measurement_timestamp,
    solar_radiation,
    CASE 
        WHEN solar_radiation BETWEEN 0 AND 200 THEN 'Safe'
        WHEN solar_radiation BETWEEN 200 AND 400 THEN 'Moderately safe'
        WHEN solar_radiation BETWEEN 400 AND 600 THEN 'Slightly dangerous'
        WHEN solar_radiation BETWEEN 600 AND 800 THEN 'Dangerous'
        ELSE 'Extremely dangerous'
    END AS radiation_danger,
    hour_e,
    day_e,
    month_e,
    year_e,
    sensor_latitude,
    sensor_longitude
FROM dbt_blue.fact_sensors_data