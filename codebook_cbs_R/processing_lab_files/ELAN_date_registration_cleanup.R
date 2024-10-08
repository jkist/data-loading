#' This file generates a specific starting and ending date for the registration at the GP practice for all patients from
#' the patient file and action file. 
# It also combines the starting
#' and ending date based on the two files. It also calculates the number of follow up
#' days between the start and end of each generated date
#' 
#' NOTE
#' This file swaps every ending and start date of the generalised date under
#' the assumption that was an accident at the practice. For example, not all 
#' practice systems work with an "inschrijf datum" or "uitschrijfdatum", or
#' when a patient switches practices in certain systems the "uitschrijfdatum" 
#' becomes an older date than the new "inschrijfdatum" which generates false negative follow up time/days
#' 
#' This file is broadly based on ELAN Preprocess files to proxy start and proxy stop dates,
#' but does not result in the same output. Customise this as you see fit :).
#'  
#' Date: 8-10-2024
#' Author: Janet Kist

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(data.table)
library(future)
 
patfile<-r"(H:/data/raw/ELAN/ELAN/original_rds_files_2023/23_elan_pat.rds)"
actfile <- r"(H:/data/raw/ELAN/ELAN/original_rds_files_2023/23_elan_act.rds)"


uploaddate <- "2023-05-01"
icpcdate <- "2000-01-01"

#'define as a date 
enddate <- as.Date(uploaddate, format = "%Y-%m-%d")
startdate <- as.Date("1990-01-01", format = "%Y-%m-%d")

patfile_process <- function(patfile){
  patfile <- setDT(readRDS(patfile))
  patfile[, patient_start := min(dInschrijfdatum), by = c("RINPERSOONS", "RINPERSOON")]
  patfile[patient_start < startdate, patient_start := startdate]
  patfile[, patient_end := max(dUitschrijfdatum), by = c("RINPERSOONS", "RINPERSOON")]
  patfile[patient_end > enddate, patient_end := enddate]
  patfile <- patfile[, c("RINPERSOONS", "RINPERSOON", "patient_start", "patient_end")]
  patfile <- unique(patfile)
  patfile[patient_start > patient_end, ':='(patient_start = patient_end, patient_end = patient_start)]
  return(patfile)
}

actfile_process <- function(actfile){
  actfile <- setDT(readRDS(actfile))
  actfile[, act_start := min(dDatum), by = c("RINPERSOONS", "RINPERSOON")]
  actfile[, act_end := max(dDatum), by = c("RINPERSOONS", "RINPERSOON")]
  actfile <- actfile[!((RINPERSOON == "000000000") | is.na(RINPERSOON) | is.na(act_start))]
  actfile[, dDatum := NULL]
  actfile <- unique(actfile)
  actfile[act_start > act_end, ':='(act_start = act_end, act_end = act_start)]
  return(actfile)
}


#Let's execute these functions in parallel and just get them from the environment

plan(multisession)
job_pat %<-% patfile_process(patfile)
job_act %<-% actfile_process(actfile)

data <- lapply(ls(pattern="job_"), get)

# custom merge function that should be native to the data.table lib
themerge <- function(x,y){
  return (merge(x, y, by=c("RINPERSOONS", "RINPERSOON"), all = TRUE)) # change to PatientID and OrganisatieID when working with ELAN GP in LUMC environment
}

file <- Reduce(themerge, data)

# Create a start an end variable that takes pat and act in account
# It just takes the lowest value of the three start attributes
file[, reg_start := pmin(patient_start, act_start, na.rm = TRUE)]
file[, reg_end := pmax(patient_end, act_end, na.rm = TRUE)]

# Remove people who do not have a duration
file <- file[!(is.na(reg_start) | is.na(reg_end))]

# Calculate difference in days
file[!(is.na(patient_start) | is.na(patient_end)), pat_duration := patient_end - patient_start]
file[!(is.na(act_start) | is.na(act_end)), act_duration := act_end - act_start]
file[!(is.na(icpc_start) | is.na(icpc_end)), icpc_duration := icpc_end - icpc_start]
file[!(is.na(reg_start) | is.na(reg_end)), reg_duration := reg_end - reg_start]


