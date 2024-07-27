{{ config(materialized='table') }}

SELECT
    Sensor_Name,
    Sensor_Type,
    Sensor_Latitude,
    Sensor_Longitude,
    Sensor_Location
FROM read_csv('./data_ingestion/00.backup/zones/zones.csv')