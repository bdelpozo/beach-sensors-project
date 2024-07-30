{{ config(materialized='view') }}

WITH relevant_data AS (
    SELECT
        UUID() AS ID,
        station_name,
        measurement_timestamp,
        air_temperature,
        humidity,
        wind_direction,
        wind_speed,
        maximum_wind_speed,
        barometric_pressure,
        solar_radiation,
        battery_life,
        measurement_id,
        hour_e,
        day_e,
        month_e,
        year_e,
        sensor_latitude,
        sensor_longitude
    FROM {{ ref('enriched_sensors_data') }}
)

SELECT *
FROM relevant_data