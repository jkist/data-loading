"""
title: get_newest_sav_file_from_dir.py
description: Python script that can be used to get the newest sav file from a dir
date: 06-05-2024
author: Lisette de Schipper
"""
from os import path
from glob import glob

if __name__ == '__main__':
    files = glob(r"../dummy_data/*.sav")
    print(max(files, key=path.getctime))    
