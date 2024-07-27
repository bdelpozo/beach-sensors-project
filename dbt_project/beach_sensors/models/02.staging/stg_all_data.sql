{{ config(materialized='table') }}
WITH data_2015 AS (SELECT station_name, measurement_timestamp, air_temperature, wet_bulb_temperature, humidity, rain_intensity, interval_rain, total_rain, precipitation_type, wind_direction, wind_speed, maximum_wind_speed, barometric_pressure, solar_radiation, heading, battery_life, measurement_timestamp_label, measurement_id FROM {{ ref('2015_data') }}),
data_2016 AS (SELECT station_name, measurement_timestamp, air_temperature, wet_bulb_temperature, humidity, rain_intensity, interval_rain, total_rain, precipitation_type, wind_direction, wind_speed, maximum_wind_speed, barometric_pressure, solar_radiation, heading, battery_life, measurement_timestamp_label, measurement_id FROM {{ ref('2016_data') }}),
data_2017 AS (SELECT station_name, measurement_timestamp, air_temperature, wet_bulb_temperature, humidity, rain_intensity, interval_rain, total_rain, precipitation_type, wind_direction, wind_speed, maximum_wind_speed, barometric_pressure, solar_radiation, heading, battery_life, measurement_timestamp_label, measurement_id FROM {{ ref('2017_data') }})
SELECT * FROM data_2015
        UNION ALL
        SELECT * FROM data_2016
        UNION ALL
        SELECT * FROM data_2017