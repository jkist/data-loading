"""
title: loading_saving_parquet.py
description: Python script that shows simple methods on how to convert a sav file to
a parquet file, how to save the respective file, and how to load in a parquet
file.
date: 10-05-2024
author: Lisette de Schipper
"""
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd

# Simple method of converting a sav file to parquet
filepath = r"../dummy_data/simpledummysetbig.sav"
destination = r"../dummy_data/destination.parquet"

df = pd.read_spss(filepath)
pq.write_table(pa.Table.from_pandas(df), destination)

# Reading in a parquet file to a Pandas dataframe
pdf = pd.read_parquet(destination, engine='pyarrow')