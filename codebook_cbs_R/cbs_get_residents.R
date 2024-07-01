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
#' get_residents(2010, municipalities=1783)
#' get_residents(2010, c("1916","0553", "0569"))

#set the working directory to the directory THIS file is in
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(foreign)
source("get_latest_sav_file.R")


get_residents <- function(year, municipalities){
  if (missing(year) | missing (municipalities)) {
    stop("Argument(s) not provided by user.")
  }
  
  residences_df <- read.spss(get_latest_sav_file(r"(G:\BouwenWonen\VSLGTAB)"),
                  to.data.frame = TRUE, 
                  use.value.labels = FALSE)
  
  residents_df <- read.spss(get_latest_sav_file(r"(G:\Bevolking\GBAADRESOBJECTBUS)"),
                            to.data.frame = TRUE,
                            use.value.labels = FALSE)
  

  residences_df <- residences_df[residences_df[, paste("gem", year, sep="")] %in% municipalities,
                                 c(1, 2)]
  
  return(merge(residences_df, residents_df))
}