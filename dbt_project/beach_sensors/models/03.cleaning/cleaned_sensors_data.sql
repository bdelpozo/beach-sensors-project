{{ config(materialized='table') }}

WITH removed_duplicates AS (
    SELECT DISTINCT 
        *
    FROM 
        {{ ref('stg_all_data') }}
), right_range_aspects AS (
    SELECT
        *
    FROM removed_duplicates
    WHERE air_temperature BETWEEN -90 AND 60
        AND humidity BETWEEN 0 AND 100
        AND barometric_pressure BETWEEN 870 AND 1084
        AND solar_radiation BETWEEN 0 AND 1361
), right_stations AS (
    SELECT
        *
    FROM right_range_aspects
    WHERE station_name in ('63rd Street Weather Station', 'Foster Weather Station', 'Oak Street Weather Station')
), right_date AS (
    SELECT
        *
    FROM right_stations
    WHERE measurement_timestamp BETWEEN '2015-12-17 03:00:00' AND '2024-07-01 00:00:00'
)

SELECT *
FROM right_date