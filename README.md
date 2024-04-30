# data-loading
Code to load data properly


## Files of interest
| Name | Function |
|------|----------|
| load_single_sav_file.Rmd | Example of reading in a single sav file |
| load_multiple_sav_files.Rmd | Examples of reading in multiple sav files. |
| get_sav_files_from_dir.Rmd | Example of getting the paths of all sav files nested in a dir. |
| loading_saving_parquet_dir.Rmd | Use this example to increase your load time. |

## Folder Structure

. src
│   ├── dummy_data
│   │   ├── nested_dummy_dir
│           ├── simpledummyset.sav
│   ├── simpledummyset.sav
│   ├── simpledummyset2.sav
├── create_dummy_data
├── get_sav_files_from_dir.Rmd (and .nb.html)
├── load_multiple_sav_files.Rmd (and .nb.html)
├── load_single_sav_file.Rmd (and .nb.html)
├── loading_saving_parquet.Rmd (and .nb.html)
├── LICENSE
├── README
├── .gitignore