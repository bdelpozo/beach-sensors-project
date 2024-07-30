{{ config(materialized='view') }}

WITH relevant_data AS (
    SELECT *,
    EXTRACT(DAY FROM measurement_timestamp) AS day_e,
    EXTRACT(MONTH FROM measurement_timestamp) AS month_e,
    EXTRACT(YEAR FROM measurement_timestamp) AS year_e,
    EXTRACT(HOUR FROM measurement_timestamp) AS hour_e,
    dim_zones.Sensor_Latitude AS sensor_latitude,
    dim_zones.Sensor_Longitude AS sensor_longitude
    FROM 
    {{ ref('cleaned_sensors_data') }} 
        LEFT JOIN dim_zones ON station_name = Sensor_Name
)

SELECT *
FROM relevant_data