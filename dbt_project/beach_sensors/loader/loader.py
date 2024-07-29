import duckdb
import pandas as pd
import os

def create_output(layer, dest_dir, dest_file):
    output_dir = f"./datalake/{layer}_layer/chicago_city_data/beach-sensors/{dest_dir}/"
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, f"{dest_file}.csv")
    return output_file

def silver_layer():
    output_file = create_output('silver', 'fact_sensors', 'fact_sensors_data')

    conn = duckdb.connect("dev.duckdb")
    query = """SELECT * FROM dbt_blue.fact_sensors_data"""
    df = conn.execute(query).df()
    df.to_csv(output_file, index=False)

    output_file = create_output('silver', 'humidity', 'humidity')
    query = """SELECT * FROM dbt_blue.humidity"""
    df = conn.execute(query).df()
    df.to_csv(output_file, index=False)

    output_file = create_output('silver', 'solar_radiation', 'solar_radiation')
    query = """SELECT * FROM dbt_blue.solar_radiation"""
    df = conn.execute(query).df()
    df.to_csv(output_file, index=False)


def gold_layer():
    conn = duckdb.connect("dev.duckdb")
    
    output_file = create_output('gold', 'avg_humidity_solar_rad', 'avg_humidity_solar_rad')
    query = """SELECT * FROM dbt_blue.avg_solar_radiation_humidity"""
    df = conn.execute(query).df()
    df.to_csv(output_file, index=False)

    output_file = create_output('gold', 'avg_humidity', 'avg_humidity_month')
    query1 = """SELECT 
        AVG(humidity) AS avg_humidity,
        month_name AS month
    FROM dbt_blue.humidity
        LEFT JOIN dbt_blue.dim_date ON month_e = dim_date.month
    GROUP BY month_name, month_e
    ORDER BY month_e
    """
    df = conn.execute(query1).df()
    df.to_csv(output_file, index=False)

    output_file = create_output('gold', 'avg_solar_radiation', 'avg_solar_radiation_month')
    query2 = """
    SELECT 
        MAX(solar_radiation) AS solar_radiation,
        month_name AS month
    FROM dbt_blue.solar_radiation
        LEFT JOIN dbt_blue.dim_date ON month_e = dim_date.month
    GROUP BY month_name, month_e
    ORDER BY month_e
    """
    f = conn.execute(query2).df()
    df.to_csv(output_file, index=False)

def main():
    print("Loading data to silver and gold layers...")
    silver_layer()
    gold_layer()
    print("Data loaded into silver and gold layer")

if __name__ == "__main__":
    main()