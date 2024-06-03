"""
title: load_single_sav_file.py
description: Python script that can be used to load a single sav file
date: 13-05-2024
author: Lisette de Schipper
"""
import pandas as pd
df = pd.read_spss(r"../dummy_data/simpledummyset.sav")
print(df.head(5))