"""
title: get_sav_files_from_dir.py
description: Python script that can be used to get all the sav files from a directory and its subdirectories
date: 06-05-2024
author: Lisette de Schipper
"""
from os import path
from glob import glob

if __name__ == '__main__':
    files = glob(r"../dummy_data/**/*.sav", recursive = True)
    print(files)