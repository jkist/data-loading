#' !!!!!!!!!!!!!!!!!!!!!
#' !!!! DEPRECIATED !!!!
#' !!!!!!!!!!!!!!!!!!!!!
#' 
#' Function that presents a standardised way to get BMIS, both coded as
#' BMI and BMI calculated from height and weight
#'  
#' For the calculation, the user can give a margin. Measurements of weights
#' will be matched with measurements of height if the dBepalingdatum of the
#' weight is within MARGIN days of the dBepalingdatum of height.
#' In other words: [dBepalingdatum - margin, dBepalingdatum + margin]
#' 
#' This does mean that it may combine the same weight measurement with multiple
#' height measurements.
#' 
#' Date: 28-6-2024
#' @author Jonne ter Braake
#' @author Ammar Faiq 
#' @author Janet Kist 
#' @author Sukainah Alfaraj
#' @author Lisette de Schipper
#' @param data data table that you want to use
#' @param margin of days to scour for matching weight and height measurements
#' If this is 10, it would look for weights up until 10 days before and
#' 10 days after the height measurement.
#' @returns a data table
#' @example
#' data <- get_numeric_bmi(data, 10)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("get_numeric_lab_measurements.R")
library(data.table)

get_numeric_bmi <- function(data, margin){

  # height is 560
  # bmi is c(1234, 1272)
  # weight is c(357, 2408)
  
  data <- get_numeric_lab_measurements(data, "values", c(560, 1234, 1272, 357, 2408))
  
  # bmi
  bmi <- data[dWCIANummer %in% c(1234, 1272)]
  bmi[, bmi := values]

  # height
  heightdata <- data[dWCIANummer == 560]
  heightdata[, height := values]
  # more clean up
  heightdata[Eenheid == "m",':=' (height = height * 100) (Eenheid = "cm")]
  heightdata[height < 3, height := height * 100]
  heightdata[height > 10000, height := height / 100]
  
  heightdata <- heightdata[, c("RINPERSOONS", "RINPERSOON", "dBepalingdatum", "height"), with = FALSE]
  
  # weight
  weightdata <- data[dWCIANummer %in% c(357, 2408)]
  weightdata[, weight := values]
  weightdata <- weightdata[, c("RINPERSOONS", "RINPERSOON", "dBepalingdatum", "weight"), with = FALSE]
  setnames(weightdata, "dBepalingdatum", "dBepalingdatumw")

  
  # the bmi we calculate (including the margin)
  bmi_calc <- weightdata[
    heightdata[, ':=' (minhdate = dBepalingdatum - margin, 
                       maxhdate = dBepalingdatum + margin)],
    on = .(RINPERSOONS == RINPERSOONS, RINPERSOON == RINPERSOON,
           dBepalingdatumw >= minhdate, dBepalingdatumw <= maxhdate)]
  
  # to generate a fitting dBepalingdatum
  # we pick the date in between the dBepalingdatum of the height
  # and de weight measurements as the dBepalingdatum of the calculated BMI
  bmi_calc[, dBepalingdatum := pmin(dBepalingdatum, dBepalingdatumw) + 
             abs(dBepalingdatum - dBepalingdatumw) ]
  
  bmi_calc <- bmi_calc[!(is.na(weight) | is.na(height))]
  bmi_calc[, bmi := weight / ((height/100)^2) ]
  bmi_calc[, bmi := mean(bmi, na.rm = TRUE), by = c("RINPERSOONS", "RINPERSOON", 
                                                "dBepalingdatum")]
  bmi_calc[, bmi_gen := TRUE]
  
  # now we combine the bmi measurements we got from the lab files with 
  # the bmis we calculated
  bmi <- rbindlist(list(bmi, bmi_calc), fill = TRUE)
  
  bmi <- bmi[!is.na(bmi)]
  bmi <- bmi[, c("RINPERSOONS", "RINPERSOON", "dBepalingdatum", "bmi", "bmi_gen"), with = FALSE]
  return(unique(bmi))
}
