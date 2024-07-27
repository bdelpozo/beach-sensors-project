
output_directory = "../../datalake/bronze_layer/chicago_city_data/beach-sensors/"

json_files = {
    '2015': '5rxc-uczg',
    '2016': 'qnr7-2c2k',
    '2017': 'ycf9-fxnj',
}

json_keys = [k for k in json_files.keys()]
backup_directory = "../00.backup/"

dest_file_directory_sources = "./models/01.sources/"
dest_file_directory_staging = "./models/02.staging/"