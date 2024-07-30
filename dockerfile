# Usar una imagen base de Python
FROM python:3.10-slim

# Instalar dependencias necesarias y actualizar los paquetes
RUN apt-get update && apt-get install -y \
    curl \
    unzip \  
    && rm -rf /var/lib/apt/lists/*

# Instalar dbt, el adaptador dbt-duckdb, duckdb, streamlit, pandas, pyarrow, numpy (this versions to avoid conflicts)
RUN pip install dbt dbt-duckdb dlt streamlit pandas==2.0.3 pyarrow==14.0.2 numpy==1.24.3 duckdb==0.10.3

# Instalar DuckDB CLI utilizando curl y descomprimiendo el archivo
RUN curl -L https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip -o duckdb_cli.zip \
    && unzip duckdb_cli.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/duckdb \
    && rm duckdb_cli.zip

# Establecer el directorio de trabajo en el contenedor
WORKDIR /dbt_project

# Configurar el volumen para persistencia de datos
VOLUME /dbt_project

# Comando por defecto
CMD ["bash"]
