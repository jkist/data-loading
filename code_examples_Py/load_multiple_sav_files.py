"""
title: load_multiple_sav_files.py
description: Python script that can be used to load multiple sav files
date: 13-05-2024
author: Lisette de Schipper

If you're going to do a lot of processing with a lot of data, consider 
using Dask opposed to Pandas (example provided). Dask is DESIGNED for
parallel computing, and it uses the disk if the data doesn't fit in
memory. The library is easy to use. Consider this if you're using a lot
of big datasets. Manipulate them to your heart's content, and
store the resulting dataset to a parquet file.
"""
import pandas as pd
from multiprocessing import Pool
import dask.dataframe as dd
from dask import delayed
from os import path 

def process_single_file(filepath):
    df = pd.read_spss(filepath)
    # Feel free to do some simple processing here!
    return df

def dask_process_single_file(filepath):
    df = pd.read_spss(filepath)
    df["source"] = path.basename(filepath).rpartition('.')[0]
    return df

if __name__ == '__main__':
    # Two methods are shown below. Pick your poison.

    # METHOD 1
    # Just loading in data with minimal processing
    pool = Pool(4) #or whatever number of threads you want to use
    filepaths = [r"../dummy_data/simpledummyset.sav", r"../dummy_data/simpledummyset2.sav"]
    dfs = pool.map(process_single_file, filepaths)
    ## Now, dfs contains a list of DataFrames

    # METHOD 2
    # example with dask:
    dfs = [delayed(dask_process_single_file)(file) for file in filepaths]
    ddfs = dd.from_delayed(dfs)
    # now, ddfs contains a Dask DataFrame