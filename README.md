# data-loading
Code to load data properly

Note that all these example will not run ootb (out of the box) on CBS's servers, but you should be able to run them without a problem on your own computer (provided that you have installed the packages the scripts rely on.)

## Files of interest
| Name | Function |
|------|----------|
| load_single_sav_file.Rmd | Example of reading in a single sav file |
| load_multiple_sav_files.Rmd | Examples of reading in multiple sav files. |
| get_sav_files_from_dir.Rmd | Example of getting the paths of all sav files nested in a dir. |
| loading_saving_parquet_dir.Rmd | Use this example to increase your load time. |
 get_newest_sav_from_dir.Rmd | An example on how to get the latest sav file form a directory. |

## Folder Structure

```bash
│   .gitignore
│   LICENSE
│   README.md
│   create_dummy_data.R
│   get_newest_sav_from_dir.nb.html
│   get_newest_sav_from_dir.Rmd
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
    │   simpledummyset.sav
    │   simpledummyset2.sav
    │
    └───nested_dummy_dir
            simpledummyset.sav
```