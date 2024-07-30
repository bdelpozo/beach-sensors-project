# Beach-Weather Sensors Project

This is an application that loads sensor data from Chicago beaches from an API. It stores the data in a bronze layer of a datalake, and then transformations are done with dbt. Some interesting data is stored in silver and gold layers of the datalake and it is possible to visualize some data graphs with streamlit.
Let's dive into it!


## Project Structure

Inside beach_sensors:

- `data_ingestion`: Contains ingest_1.py and const.py to ingest data into to bronze layer.
- `datalake`: Contains the datalake.
- `loader`: Contains loader.py to load data to silver and gold layers.
- `macros`: Contains WAP.sql.
- `models`: Contains dbt models.
  - `01.sources`: Contains the sources models.
  - `02.staging`: Contains the merge of all data models.
  - `03.cleaning`: Contains cleaning tasks.
  - `04.enrichment`: Contains enrichment tasks.
  - `05.structurall`: Contains structure task.
  - `98.final_data_analysis`: Contains some querys to create data for silver and bronze layers.
  - `99.datamart`: Contains fields testing specifications, fact table and dimesions tables used.
- `streamlit`: Contains app.py to visualize some data.
  
## Building

Create the image with the dockerfile

```bash
docker build --pull --rm -f "dockerfile" -t beachsensorsproject:latest "." 
```

Create the container:

```bash
docker-compose up
```

To enter into the container:

```bash
docker exec -it dbt-beach-sensors //bin/sh
```



## Running

The project uses a orchestrator for running. You can run the project using the following commands:


```sh
cd beach_sensors
```

```sh
python orchestrator.py
```



## Visualize

Some graphs can be visualize in http://localhost:8080/ with:

```sh
streamlit run ./streamlit/app.py --server.port 8080
```