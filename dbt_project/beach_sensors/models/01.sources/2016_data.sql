{{ config(materialized='view') }}

SELECT  
    station_name, measurement_timestamp, air_temperature, wet_bulb_temperature, humidity, rain_intensity, interval_rain, total_rain, precipitation_type, wind_direction, wind_speed, maximum_wind_speed, barometric_pressure, solar_radiation, heading, battery_life, measurement_timestamp_label, measurement_id
FROM read_csv('./datalake/bronze_layer/chicago_city_data/beach-sensors/2016/data_2016.csv')
    