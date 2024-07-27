import os
import pandas as pd
import const
import helper
from dlt.sources.helpers import requests

def load_json_files(file_paths):
    """Load JSON files and return them as pandas DataFrames."""
    dataframes = []
    for year, file_path in file_paths.items():
        api_url = f"https://data.cityofchicago.org/resource/{file_path}.json"
        try:
            response = requests.get(api_url)
            response.raise_for_status()
            data = response.json()
            df = pd.DataFrame(data)
            df.attrs['dlt_source_name'] = api_url
            dataframes.append((year, df))
        
        except requests.RequestException as e:
            print(f"Error fetching data from {api_url}: {e}")
            csv_path = os.path.join(const.backup_directory, f"{year}/data_{year}.csv")
            if os.path.exists(csv_path):
                try:
                    df = pd.read_csv(csv_path)
                    df.attrs['dlt_source_name'] = csv_path
                    dataframes.append((year, df))
                    print(f"Loaded CSV from backup directory for year {year}")
                except Exception as csv_e:
                    print(f"Error reading CSV from backup directory: {csv_e}")
            else:
                print(f"No backup CSV found for year {year}")
    
    return dataframes

def save_partition_to_csv(df: pd.DataFrame, partition_name: str, output_dir: str):
    """Save the DataFrame as a CSV file in a directory named after the partition."""
    partition_dir = os.path.join(output_dir, partition_name)
    os.makedirs(partition_dir, exist_ok=True)
    file_path = os.path.join(partition_dir, f"data_{partition_name}.csv")
    
    df.columns = df.columns.str.replace(' ', '_', regex=False)
    df.to_csv(file_path, index=False)
    os.makedirs(const.dest_file_directory_sources, exist_ok=True)
    dest_file_path = os.path.join(const.dest_file_directory_sources, f"{partition_name}_data.sql")
    print(f"Saved partition '{partition_name}' to {file_path}")
    helper.create_sql_file(partition_name, file_path, dest_file_path)
    return helper.create_stg_statement_1(partition_name,file_path)
    # except Exception as e:
        #print(f"Error saving CSV: {e}")

def main(file_paths, output_dir):
    dataframes = load_json_files(file_paths)
    stg_statements = []
    for partition_name, df in dataframes:
        stg_statements.append(save_partition_to_csv(df, partition_name, output_dir))
    print(stg_statements)
    os.makedirs(const.dest_file_directory_staging, exist_ok=True)
    dest_file_path = os.path.join(const.dest_file_directory_staging, "stg_all_data.sql")
    helper.create_stg_sql_file(stg_statements, dest_file_path)
if __name__ == "__main__":
    main(const.json_files, const.output_directory)