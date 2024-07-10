#' This function will get you the registered primary cause of death for all people
#' in the DO and DOODOORZTAB datasets at CBS 
#' Date: 18-06-2024
#' @author Janet Kist
#' @author Jonne ter Braake 
#' @author Lisette de Schipper
#' @param my_years of interest to get the primary cause of death.
#' @returns a dataframe
#' @examples
#' get_prim_cause_of_death(seq(1995, 2023))
#' get_prim_cause_of_death(2012)
#' get_prim_cause_of_death(c(2011, 2019))

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("cbs_get_latest_sav_files.R") # to get the data from the lab files
library(furrr)
library(data.table)
library(haven)

dirs <- c(r"(G:\GezondheidWelzijn\DO)", r"(G:\GezondheidWelzijn\DOODOORZTAB)")

filters <- list("RINPERSOONS" = c("Srtnum", "RINPERSOONS", "srtnum", "rinpersoons"),
                "RINPERSOON" = c("RIN", "RINPERSOON", "rin", "rinpersoon"),
                "uccode" = c("PRIMOORZ", "primoorz", "UCCODE"))

get_prim_cause_of_death <- function(my_years){
  files <- get_latest_sav_files(dirs)
  
  #In case the user needs a subset of years
  if (!missing(my_years)) {
    files <-files[files$year %in% my_years,]
    if (1995 %in% my_years){
      warning("The dataset from 1995 uses ICD9, whereas all the other sets use ICD10!")
    }
  }
  else{
    warning("The dataset from 1995 uses ICD9, whereas all the other sets use ICD10!")
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

    # type conversion
    data[, RINPERSOON := sprintf("%009d", as.numeric(RINPERSOON))]

    return(data)
  }
  
  plan(multisession, workers = availableCores())
  data <- future_map2_dfr(files$file, files$year, read_sav)
  return(data)
}