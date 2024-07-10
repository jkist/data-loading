#' This function will allow you to link RINPERSONEN (RINPEOPLE) with RINPERSOONHKW
#' 
#' Date: 09-07-2024
#' @author Janet Kist
#' @author Lisette de Schipper
#' @param my_years of interest (optional) to get the household income for 
#' (empty, int, or a vector of ints)
#' @returns a dataframe
#' @examples
#' get_personal_income(seq(1995, 2023))
#' get_personal_income(2012)
#' get_personal_income()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("cbs_get_latest_sav_files.R")
library(furrr)
library(data.table)
library(haven)

dirs <- c(r"(G:\InkomenBestedingen\INTEGRAAL PERSOONLIJK INKOMEN)", r"(G:\InkomenBestedingen\INPATAB)")

filters <- list("RINPERSOONS" = "RINPERSOONS",
                "RINPERSOON" = "RINPERSOON",
                "RINPERSOONSHKW" = c("RINPERSOONSKERN", "RINPERSOONSHKW"),
                "RINPERSOONHKW" = c("RINPERSOONKERN", "RINPERSOONHKW"))

get_personal_income <- function(my_years){
  files <- get_latest_sav_files(dirs, "KOPPELPERSOON")
  
  #In case the user needs a subset of years
  if (!missing(my_years)) {
    files <-files[files$year %in% my_years,]
  }
  
  # slight overhead if we only care about the primary cause of death for one year
  read_sav <- function(file, year){
    data <- setDT(read_spss(file, col_select = any_of(unname(unlist(filters)))))
    data <- zap_formats(zap_labels(data))
    names <- names(data)
    
    #this set-up insures the order of the columns is always the same
    columns <- sapply(filters, function(x) names[names %in% x])
    data <- data[, ..columns]
    colnames(data) <- names(filters)
    
    data[, year := year]
    
    return(data)
  }
  plan(multisession, workers = availableCores())
  data <- future_map2_dfr(files$file, files$year, read_sav)
  return(data)
}