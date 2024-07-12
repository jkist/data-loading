#' We've developed some functions that convert some data sets at CBS to parquet files.
#' (cbs_save_healthcare_to_parquet and cbs_save_diagnoses_to_parquet)
#' May as well provide a function to (quickly!) load those in!
#' 
#' Date: 26-06-2024
#' @author Lisette de Schipper
#' @param location the parquet files are saved at
#' @param subject of interest, in this case, that's either "Diagnoses" or "Healthcarecosts"
#' @param years of interest
#' @returns a data frame
#' @examples
#' get_parquet_files(r"(H:\BruceWillis\VEKTIS)", "Diagnoses", c(2016, 2017))
#' get_parquet_files(r"(H:\BruceWillis\VEKTIS", "Healthcarecosts")

library(furrr)
library(arrow)

files <- c("Diagnoses" = "MSZPrestatiesVEKT",
           "Healthcarecosts" = "ZVWZORGKOSTEN")

get_parquet_files <- function(location, subject="", years){
  if (missing(location) | missing(subject)){
    warning("Argument missing!")
  }
  if (!(subject %in% names(files))){
    warning(paste("The given subject is invalid. The user can currently pick from", files))
  }
  
  pattern = paste0("^", files[subject], ".*\\.parquet$")
  yearpattern = ".*([0-9]{4})\\.parquet$" 
  file <- list.files(location, pattern = pattern, full.names = TRUE, recursive = TRUE)
  year <- sapply(file, function(x) gsub(yearpattern, "\\1", x))
  year <- setNames(names(year), year)
  
  if (!missing(years)){
    year <- year[as.character(years)]
  }
  
  plan(multisession, workers = availableCores())
  data <- future_map_dfr(year, read_parquet)
  return(data)
}


