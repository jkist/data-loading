#' This function will get you the medication data from whatever years you desire
#' from CBS's MEDICIJNTAB. Since 2020, the datasets include daily defined dosages (DDD).
#' For the remaining years, the values for DDD are set to NAN.#' 
#' 
#' Date: 19-06-2024
#' @author Janet Kist
#' @author Jonne ter Braake
#' @author Lisette de Schipper
#' @param my_years of interest
#' @returns a dataframe
#' @examples
#' get_med(seq(2006, 2022))
#' get_med(2012)
#' get_med(c(2011, 2019))

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(furrr)
library(data.table)
library(foreign)
source("cbs_get_latest_sav_files.R")

dir <- r"(G:\GezondheidWelzijn\MEDICIJNTAB\)"

get_med <- function(my_years){
  
  files <- get_latest_sav_files(dir)

  #In case the user needs a subset of years
  if (!missing(my_years)) {
    files <-files[files$year %in% my_years,]
  }
  
  # slight overhead if we only care about one year
  read_sav <- function(file, year){
    data <- setDT(read.spss(file, to.data.frame=FALSE, use.value.labels = FALSE))
    data[, year := year]
    
    if (!"DDD" %in% colnames(data)){
      data[, DDD := NA]  
    }
    
    # type conversion
    data[, RINPERSOON := sprintf("%009d", as.numeric(RINPERSOON))]
    
    return(data)
  }
  plan(multisession, workers = availableCores())
  data <- future_map2_dfr(files$file, files$year, read_sav)
  return(data)
}