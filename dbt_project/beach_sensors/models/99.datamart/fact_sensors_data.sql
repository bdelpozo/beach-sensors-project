{{ config(materialized='table') }}
WITH _tmp_data AS (
    SELECT 
        *,
        NOW() audit_row_insert,
        'dbt_beach_sensors' audit_process_id
    FROM 
        {{ ref('sgt_fact_sensors')}}
)

SELECT *
FROM _tmp_data