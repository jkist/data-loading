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

```bash
│   .gitignore
│   LICENSE
│   README.md
│   create_dummy_data.R
│   get_sav_files_from_dir.nb.html
│   get_sav_files_from_dir.Rmd
│   loading_saving_parquet.nb.html
│   loading_saving_parquet.Rmd
│   load_multiple_sav_files.nb.html
│   load_multiple_sav_files.Rmd
│   load_single_sav_file.nb.html
│   load_single_sav_file.Rmd
│
└───dummy_data
    │   converted_simpledummyset.parquet
    │   simpledummyset.sav
    │   simpledummyset2.sav
    │
    └───nested_dummy_dir
            simpledummyset.sav
```