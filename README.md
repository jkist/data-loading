# data-loading
Code to load data properly, organised per programming language in their own folder.

Note that all these example will not run ootb (out of the box) on CBS's servers (since you do not have the rights to change the working directory), but you should be able to run them without a problem on your own computer (provided that you have installed the packages the scripts rely on.)

## Files of interest in folder code_examples_R
| Name | Function |
|------|----------|
| load_single_sav_file.Rmd | Example of reading in a single sav file |
| load_multiple_sav_files.Rmd | Examples of reading in multiple sav files. |
| get_sav_files_from_dir.Rmd | Example of getting the paths of all sav files nested in a dir. |
| loading_saving_parquet_dir.Rmd | Use this example to increase your load time. |
 get_newest_sav_from_dir.Rmd | An example on how to get the latest sav file form a directory. |

## Reading dirty csv files
Some R packages can not handle a csv file with extra quotes and will return only part of the file. See 20240506_reading_dirty_csv

## Folder Structure

```bash
│   .gitignore
│   LICENSE
│   README.md
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
├───20240506_reading_dirty_csv
│		readme.md
│		dirty_csv.Rmd
│		dirty_csv.html
│
└───dummy_data
    │   simpledummyset.sav
    │   simpledummyset2.sav
	|	dirty_csv.csv
    │
    └───nested_dummy_dir
            simpledummyset.sav
```
