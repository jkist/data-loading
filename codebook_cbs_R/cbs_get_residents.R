#' This function will return the residents for all years for municipalities of
#' interest. The user determines what year is used for the gemeentelijke
#' indeling.
#' Date: 17-06-2024
#' @author Janet Kist
#' @author Lisette de Schipper
#' @param year of interest for the municipal structure (required). The municipalities of 
#' the Netherlands get restructured.
#' In Dutch, these are called 'herindelingen'. For instance, a municipality 
#' can get absorbed by another, meaning that their records change.
#' You are required to pick a year of interest. You can find 'gemeentelijke indelingen'
#' on the website op CBS: cbs.nl/nl-nl/onze-diensten/methoden/classificaties/overig/gemeentelijke-indelingen-per-jaar
#' @param municipalities of interest (required)
#' @returns a dataframe
#' @examples
#' get_residents(2009)
#' get_residents(2010, municipalities = "1783")
#' get_residents(2010, c("1916", "0553", "0569"))

#set the working directory to the directory THIS file is in
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(foreign)
library(furrr)
library(data.table)
source("get_latest_sav_file.R")

get_residents <- function(year, municipalities){
  if (missing(year) | missing (municipalities)) {
    stop("Argument(s) not provided by user.")
  }

  get_file <- function(dir){
    return(setDT(read.spss(get_latest_sav_file(dir), to.data.frame = TRUE, use.value.labels = FALSE)))    
  }
  
  plan(multisession, workers = availableCores())
  residents_df <- future_map(c(r"(G:\BouwenWonen\VSLGTAB)", 
                               r"(G:\Bevolking\GBAADRESOBJECTBUS)"), get_file)
  
  if (length(municipalities) == 1) {
    residents_df[[1]] <- residents_df[[1]][which(residents_df[[1]][, paste0("gem", year),  with = FALSE] == municipalities[1]), c(1,2)]
  }
  else {

    residents_df[[1]] <- residents_df[[1]][which(residents_df[[1]][, paste0("gem", year), with = FALSE] %in% municipalities), c(1,2)]
  }

  return(merge(residents_df[[1]], residents_df[[2]]))
}