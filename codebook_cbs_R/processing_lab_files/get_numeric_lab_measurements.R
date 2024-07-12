#' If you have a file containing lab measurements that conforms to
#' get_lab_measurements.R, this function can be used to get integer data
#' 
#' We do highly recommend going through all the (g)subs in this file. Your
#' one or multiple dWCIAnum may require different clean-up steps.
#'  
#' Date: 28-6-2024
#' @author Jonne ter Braake
#' @author Ammar Faiq 
#' @author Janet Kist 
#' @author Lisette de Schipper
#' @param data data table that you want to use
#' @param condition the name of the column that will contain the numeric values
#' @param dWCIAnum of interest or multiple
#' @param rounding (optional) number of digits to round to
#' @returns a data table
#' @examples
#' data <- get_numeric_lab_measurements(data, "sbp", 1744, 0)
#' data <- get_numeric_lab_measurements(data, "ldlCholesterol", c(542, 2683))

library(data.table)

get_numeric_lab_measurements <- function(data, condition, dWCIAnum, rounding){
  data <- data[dWCIANummer %in% dWCIAnum]
  # Note that you should do something like below ONCE on the entire dataset if 
  # you KNOW you're using numeric values. 
  # Do ditch the data set of the non-numeric ones first.
  
  # Change commas to periods (taking into account spaces)
  data[, condition := gsub("[[:blank:]]*,+[[:blank:]]*", ".", Resultaat)]
  # Remove /n where n is whatever
  data[, condition := gsub("/[:alnum:]*", "", condition)]
  # Remove trailing things that aren't numbers (alnum, punct, and spaces)
  data[, condition := gsub("[^0-9]+$", "", condition)]
  # Remove leading things that aren't numbers (alnum, punct, and spaces)
  data[, condition := gsub("^[^0-9]+", "", condition)]
  # change multiple periods and spaces to one period
  data[, condition := gsub("\\.{2,}", ".", condition)]
  # remove spaces around period
  data[, condition := gsub("[[:blank:]]*,+[[:blank:]]*", ".", condition)]
  # Just remove `
  data[, condition := gsub("`", "", condition)]
  
  # now a decision had to be made.
  # sometimes a space is accidentally put in between numbers
  # sometimes a space is put in to indicate a period
  # change anything that isn't a number to a period
  data[, condition := gsub("[^0-9]+", ".", condition)]

  data <- data[condition != ""]
  
  # pick records that conform to n.m or n. or n
  # You could leave this out and do some manual clean-up
  # This would also affect the subsetting of course.
  # Feel free to reach out if you have questions.
  data <- data[grepl("^([0-9]+)\\.?([0-9]*)$", condition)]
 

  data[, condition := abs(as.numeric(condition))]
  if (!missing(rounding)){
    data[, condition := round(condition, digits = rounding)]
  }

  #remove where condition is na and subset columns
  data <-  data[!is.na(condition),.(RINPERSOONS, RINPERSOON, dBepalingdatum,
                                    condition, Eenheid,dWCIANummer)]
  
  # Change column name
  setnames(data, "condition", condition)
  return(unique(data))
}