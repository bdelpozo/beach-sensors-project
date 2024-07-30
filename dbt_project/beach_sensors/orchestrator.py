import subprocess
import os

def run_dlt_load():
    print("Starting data loading with DLT...")
    try:
        subprocess.run(['python', 'data_ingestion/00.ingestion/ingest_1.py'], check=True)
        print("Data upload completed.")
    except subprocess.CalledProcessError as e:
        print(f"Data loading error: {e}")
        raise

def run_dbt_transform():
    print("Starting data transformation with DBT...")
    try:
        subprocess.run(['dbt', 'deps'], check=True)
        subprocess.run(['dbt', 'run'], check=True)
        print("Data transformations completed.")
    except subprocess.CalledProcessError as e:
        print(f"Error in data transformations: {e}")
        raise

def run_dbt_test():
    try:
        subprocess.run(['dbt', 'test'], check=True)
        print("Completed tests.")
    except subprocess.CalledProcessError as e:
        print(f"Error in test: {e}")
        raise

def run_blue_to_green():
    try:
        subprocess.run(['dbt', 'run-operation','publish', '--profiles-dir', '.', '--target', 'green'], check=True)
        print("Merged into green.")
    except subprocess.CalledProcessError as e:
        print(f"Error merging into green: {e}")
        raise

def run_load_data_to_datalake_layers():
    try:
        subprocess.run(['python', 'loader/loader.py'], check=True)
        print("Completed loading.")
    except subprocess.CalledProcessError as e:
        print(f"Error in loading: {e}")
        raise

def main():
    print('Welcome to BeachWeather ETL!')
    run_dlt_load()
    run_dbt_transform()
    run_dbt_test()
    run_blue_to_green()
    run_load_data_to_datalake_layers()
    print('END')
    
if __name__ == "__main__":
    main()