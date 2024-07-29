import pandas as pd
import csv
import const
def create_sql_file(partition_name, file_path, dest_file_path):
    df = pd.read_csv(file_path, nrows=0)
    header = ', '.join(df.columns)  # Join column names into a single string
    sql_content = f"""{{{{ config(materialized='view') }}}}

SELECT  
    {header}
FROM read_csv('./datalake/bronze_layer/chicago_city_data/beach-sensors/{partition_name}/data_{partition_name}.csv')
    """
    print(sql_content)
    try:
        with open(dest_file_path, 'w') as file:
           file.write(sql_content) 
    except Exception as e:
        print(f"file sql no se pudo generar: {e}")
    

def create_stg_statement_1(partition_name, file_path):
    df = pd.read_csv(file_path, nrows=0)
    header = ', '.join(df.columns)
    sql_content_1 = f"""SELECT {header} FROM {{{{ ref('{partition_name}_data') }}}}"""
    return sql_content_1


def create_stg_sql_file(list_stg_statements, dest_file_path):
    length = len(const.json_keys)
    # cambiar a view una vez probado
    sql_first_statement = f"""{{{{ config(materialized='view') }}}}\n"""
    
    # statement 1
    sql_content_1 = f"""WITH data_{const.json_keys[0]} AS ({list_stg_statements[0]}),\n"""
    for i in range(1, length-1):
        sql_content_1 += f"""data_{const.json_keys[i]} AS ({list_stg_statements[i]}),\n"""
    sql_content_1 += f"""data_{const.json_keys[-1]} AS ({list_stg_statements[-1]})\n"""
    # statement 2
    sql_content_2 = ''
    for i in range(length-1):
        sql_content_2 += f"""SELECT * FROM data_{const.json_keys[i]}
        UNION ALL
        """
    sql_content_2 += f"""SELECT * FROM data_{const.json_keys[-1]}"""

    sql_content = sql_first_statement + sql_content_1 + sql_content_2
    print(sql_content)
    try:
        with open(dest_file_path, 'w') as file:
           file.write(sql_content) 
    except Exception as e:
        print(f"file sql no se pudo generar: {e}")