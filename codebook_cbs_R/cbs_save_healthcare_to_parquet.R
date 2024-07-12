#' This function extracts some columns from ZVWZORGKOSTEN and converts them to parquet files.
#' The user can pass an argument to indicate what years they're interested in.
#' 
#' The idea is that the parquet files are stored somewhere obvious: where all
#' researchers can find them, then the code is ran every time a year is updated or added.
#' Date: 25-06-2024
#' @author Janet Kist
#' @author Jonne ter Braake
#' @author Lisette de Schipper
#' @param my_years of interest
#' @param destination directory the files will be saved in
#' @param columnfilter If this is set to FALSE, all columns will be included,
#' otherwise a selection will be made (GP, Hospital and Multidisiplinary if they're available)
#' @returns list of saved years
#' @examples
#' save_costs_to_parquet(c(2017, 2019))
#' save_costs_to_parquet(destination = "parquet/")
#' save_costs_to_parquet(2019, "directoryfactory")
#' save_costs_to_parquet(2019, columnfilter = NULL )


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(furrr)
library(data.table)
library(haven)
library(arrow)
library(readxl)

dir <- r"(G:\GezondheidWelzijn\)"

filters <- c("RINPERSOONS", "RINPERSOON", "ZVWKHUISARTS",
                "ZVWKZIEKENHUIS", "ZVWKMULTIDISC")

save_costs_to_parquet <- function(my_years, destination = "", columnfilter = TRUE){
  
  file <- list.files(dir, pattern = "^ZVWZORGKOSTEN.*\\.sav$", full.names = TRUE, recursive = TRUE)
  #get the year
  pattern = ".*/ZVWZORGKOSTEN(.+)TAB.*"
  year <- sapply(file, function(x) gsub(pattern, "\\1", x))
  year <- unname(year)
  #get the latest ones
  mtime <- file.mtime(file)
  df <- data.frame(file, year, mtime)
  df <- df[order(year, mtime),]
  df <- df[!duplicated(df$year, fromLast = TRUE),]
  
  #if a file has mtime NA, that means it's not accessible to the researcher, so just kill it.
  df <- na.omit(df)
  
  #In case the user needs a subset of years
  if (!missing(my_years)) {
    df <-df[df$year %in% as.character(my_years),]
  }

  convert_to_parquet <- function(file, year){
    if(columnfilter){
      data <- setDT(read_spss(file, col_select = any_of(filters)))
    }
    else{
      data <- setDT(read_spss(file))   
    }
    # Kill all the metadata
    data <- zap_formats(zap_labels(data))
  
    data[, year := year]

    # type conversion
    data[, RINPERSOON <= sprintf("%009d", as.numeric(RINPERSOON))]
    
    write_parquet(data, paste0(destination, "ZVWZORGKOSTEN", year, ".parquet"))

    return(year)
  }
  
  plan(multisession, workers = availableCores())
  data <- future_map2_chr(df$file, df$year, convert_to_parquet)
  
  cat("The following years have been saves as parquet files:", data)
  return(data)
}
