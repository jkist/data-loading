#' This function extracts some columns from MSZPrestaties and converts them to parquet files.
#' The user can pass an argument to indicate what years they're interested in.
#' 
#' The idea is that the parquet files are stored somewhere obvious: where all
#' researchers can find them, then the code is ran every time a year is updated or added.
#' 
#' Definitely check out the cbs_select_diagnoses Rmd file for an example on how to (efficiently)
#' make a selection of diagnoses!
#' 
#' Date: 24-06-2024
#' @author Janet Kist
#' @author Jonne ter Braake
#' @author Lisette de Schipper
#' @param my_years of interest
#' @param directory the files will be saved in
#' @returns list of saved years
#' @examples
#' save_diagnoses_to_parquet(c(2017, 2017))
#' save_diagnoses_to_parquet(destination="parquet/",decoded=TRUE)
#' save_diagnoses_to_parquet(decoded=TRUE)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(furrr)
library(data.table)
library(haven)
library(arrow)

dir <- r"(G:\GezondheidWelzijn\)"

filters <- c("RINPERSOONS", "RINPERSOON", "VEKTMSZBegindatumPrest",
                "VEKTMSZSpecialismeDiagnoseCombinatie", "VEKTMSZSettingZPK")

save_diagnoses_to_parquet <- function(my_years, destination = ""){
  
  file <- list.files(dir, pattern = "^MSZPrestatiesVEKT.*\\.sav$", full.names = TRUE, recursive = TRUE)
  #get the year
  pattern = ".*/MSZPrestatiesVEKT(.+)TAB.*"
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
    data <- setDT(read_spss(file,col_select = all_of(filters)))
    # Kill all the metadata
    data <- zap_formats(zap_labels(data))
    data <- data[VEKTMSZSpecialismeDiagnoseCombinatie != "9999-99-99-9999"]
    data[,"year":=year]

    # type conversion
    data$RINPERSOON <- sprintf("%009d", as.numeric(data$RINPERSOON))

    write_parquet(data, paste0(destination, "MSZPrestatiesVEKT", year, ".parquet"))

    return(year)
  }
  
  plan(multisession, workers = availableCores())
  data <- future_map2_chr(df$file, df$year, convert_to_parquet)
  
  cat("The following years have been saves as parquet files:", data)
  return(data)
}

save_diagnoses_to_parquet(destination = "parquet/")
