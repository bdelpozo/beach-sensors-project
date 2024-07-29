from datetime import datetime
import streamlit as st
import matplotlib as plt
import duckdb
import pandas as pd

st.title("Beach Weather Streamlit")
con = duckdb.connect("dev.duckdb")
month_order = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
]

st.header('Average Humidity Level per Month')
query1 = """
SELECT 
    AVG(humidity) AS avg_humidity,
    month_name AS month,
    month_e
FROM dbt_blue.humidity
    LEFT JOIN dbt_blue.dim_date ON month_e = dim_date.month
GROUP BY month_name, month_e
ORDER BY month_e
"""

df = con.execute(query1).df()
df['month'] = pd.Categorical(df['month'], categories=month_order, ordered=True)
df = df.sort_values('month')
df.set_index('month', inplace=True)
st.bar_chart(df['avg_humidity'], color='#32CD32')


st.header('Maximun Solar Radiation Levels Recorded per Month')
query2 = """
SELECT 
    MAX(solar_radiation) AS solar_radiation,
    month_name AS month,
    month_e
FROM dbt_blue.solar_radiation
    LEFT JOIN dbt_blue.dim_date ON month_e = dim_date.month
GROUP BY month_name, month_e
ORDER BY month_e
"""
df = con.execute(query2).df()
df['month'] = pd.Categorical(df['month'], categories=month_order, ordered=True)
df = df.sort_values('month')
df.set_index('month', inplace=True)
st.bar_chart(df['solar_radiation'], color='#FF8000')
