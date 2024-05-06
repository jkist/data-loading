# data-loading
Code to load data properly, organised per programming language in their own folder.

Note that all these example will not run ootb (out of the box) on CBS's servers (since you do not have the rights to change the working directory), but you should be able to run them without a problem on your own computer (provided that you have installed the packages the scripts rely on.)

## Files of interest in folder code_examples_R
| Name | Function |
|------|----------|
| load_single_sav_file.Rmd | Example of reading in a single sav file |
| load_multiple_sav_files.Rmd | Examples of reading in multiple sav files. |
| get_sav_files_from_dir.Rmd | Example of getting the paths of all sav files nested in a dir. |
| loading_saving_parquet_dir.Rmd | Use this example to increase your load time. It shows you how to read in and save parquet files in addition to converting a sav file to the Apache Parquet format. |
| get_newest_sav_from_dir.Rmd | An example on how to get the latest sav file form a directory. |

## Files of interest in folder code_examples_Py
In order to run the files from home (easily), clone the repo to your local machine. If you have pip installed, you can activate whatever environment you want to use for Python, and type:

```
pip install -r requirements.txt
```

| Name | Function |
|------|----------|
| load_multiple_sav_files.Rmd | Examples of reading in multiple sav files. |
| get_sav_files_from_dir.Rmd | Example of getting the paths of all sav files nested in a dir. |
| loading_saving_parquet_dir.Rmd | Use this example to increase your load time. It shows you how to read in and save parquet files in addition to converting a sav file to the Apache Parquet format. |
| get_newest_sav_from_dir.Rmd | An example on how to get the latest sav file form a directory. |


## Folder Structure

```bash
│   .gitignore
│   .Rhistory
│   LICENSE
│   README.md
│   requirements.txt
│
├───code_examples_Py
│       get_newest_sav_from_dir.py
│       get_sav_files_from_dir.py
│       loading_saving_parquet.py
│       load_multiple_sav_files.py
│
├───code_examples_R
│       .gitignore
│       create_dummy_data.R
│       get_newest_sav_from_dir.Rmd
│       get_sav_files_from_dir.Rmd
│       loading_saving_parquet.Rmd
│       load_multiple_sav_files.Rmd
│       load_single_sav_file.Rmd
│
└───dummy_data
    │   simpledummyset.sav
    │   simpledummyset2.sav
    │
    └───nested_dummy_dir
            simpledummyset.sav
```
