#' This function loads in the lab files, does a bit of clean-up and
#' subsets. 
#' 
#' The selectionp parameter is optional. Otherwise it will default to the massive
#' sel_dWCIAnum selection.
#'  
#' Date: 28-6-2024
#' @author Jonne ter Braake
#' @author Ammar Faiq 
#' @author Janet Kist 
#' @author Lisette de Schipper
#' @param selection a list/array of dWCIANummers to select
#' @returns a data table
#' @examples
#' data <- get_lab_measurements(c(560, 1234, 1272, 357, 2408))
#' data <- get_lab_measurements()

library(data.table)
library(furrr)

sel_dWCIAnum <- c(35, seq(40, 43), 77, seq(134, 136), 181, 192, 227, 357, 359,
                  369, 371, 372, 381, 382, 412, 415, 446, 513, 523, 534, 542,
                  560, 582, 1234, 1272, 1377, 1385, 1402, 1427, 1591, 1652, 1653,
                  1713, 1740, 1744, 1814, 1856, seq(1918, 1920), seq(1966, 1968),
                  1992, 1993, 1996, 1997, seq(2001, 2003), seq(2005, 2011),
                  seq(2013, 2017), seq(2019, 2021), 2023, 2027, seq(2033, 2035),
                  seq(2037, 2039), 2043, 2047, 2059, 2131, 2139, 2190, 2223, 
                  2405, 2408, 2423, 2645, 2683, 268, 2770, 2816, 2998, 2999,
                  3020, 3208, 3209, 3235, 3238, 3241, 3266, 3267, 3446, 3482,
                  3483, 3583, 3710, 3711, 3735, seq(3739, 3741), 3754, 3755,
                  3813, 3822, 3850, seq(3851, 3860), 3907, 3923, 3924, 3949, 
                  3953, 3955)

get_lab_measurements <- function(selection = sel_dWCIAnum){
  location <- r"(H:\data\raw\ELAN)"
  
  files <- list.files(location, pattern = "LAB([0-9]{1})\\.rds$" , full.names = TRUE, recursive = TRUE)
  
  #The method below already subsets the datasets to free up memory.
  load_lab <- function(file){
    data <- setDT(readRDS(file))
    data <- data[,c( "RINPERSOONS", "RINPERSOON", "dWCIACode", "dBepalingdatum", "dWCIANummer", "dWCIAOmschrijving", "Resultaat", "Eenheid")]
    data <- data[!(is.na(RINPERSOON) | dWCIACode == "" | Resultaat == "" | is.na(dWCIANummer))]
    return (data)
  }
  
  plan(multisession, workers = availableCores())
  
  data <- future_map_dfr(files, load_lab, .options= furrr_options(packages = "data.table"))
  
  data <- unique(data)
  
  data <- data[, dBepalingdatum := as.Date(dBepalingdatum, format ="%Y-%m-%d")]
  
  data <- data[dWCIANummer %in% selection]
  
  return(data)
}