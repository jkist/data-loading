"""
title: get_newest_sav_file_from_dir.py
description: Python script that can be used to get the newest sav file from a dir
date: 13-05-2024
author: Lisette de Schipper

Additionally to getting the newest sav file in a dir, this script keeps
track of the latest file in each directory you're using by a hidden
file. A warning is given if the newest file has changed. This means
the execution of the script is not halted, but that the user is only
informed of the new file.

This script was not tested on Linux :D.
"""
from os import path
from glob import glob
import pickle
import os
import stat
import ctypes
import warnings


lastfilelist = {}

def _linux_hide(file_name):
    # For *nix add a '.' prefix.
    prefix = '.' if os.name != 'nt' else ''
    return prefix + file_name + ".pkl"

def write_hidden_pickle(file_name, mydir, mypath):
    """
    Cross platform hidden file writer.
    """
    file_name = _linux_hide(file_name)

    lastfilelist[mydir] = mypath

    # This checks if the file already exists on Windows and whether it's hidden.
    # If it's hidden, it doesn't have write permission, so let's just kill the file
    # Since we're about to save a new one.
    if (os.name == 'nt') and \
          bool(os.stat(file_name).st_file_attributes & stat.FILE_ATTRIBUTE_HIDDEN):
        os.remove(file_name)    

    # Write file.
    with open(file_name, 'wb') as f:
        pickle.dump(lastfilelist, f, protocol=pickle.HIGHEST_PROTOCOL)

    # For windows, hide file.
    if (os.name == 'nt'):
            ret = ctypes.windll.kernel32.SetFileAttributesW(file_name, 0x02)
            if not ret: # There was an error.
                raise ctypes.WinError()

def check_hidden_pickle(file_name, dir, file):
    global lastfilelist
    file_name = _linux_hide(file_name)
    
    if os.path.isfile(file_name):
        # Load file
        with open(file_name, 'rb') as f:
            lastfilelist = pickle.load(f)

        # Check if there's a new newest sav file     
        if dir in lastfilelist:
            if file != lastfilelist[dir]:
                warnings.warn(f"New file in directory {dir}.")
            

def get_latest_file(mydir):
    paths = glob(rf"{mydir}/*.sav")
    mypath = max(paths, key=path.getctime)

    check_hidden_pickle("latest_file", mydir, mypath)
    write_hidden_pickle("latest_file", mydir, mypath)

    return mypath

print(get_latest_file(r"../dummy_data/"))