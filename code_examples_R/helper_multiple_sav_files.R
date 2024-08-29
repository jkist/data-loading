library(haven)
library(data.table)

#custom class for files
setClass("File",
         slots = c(
           location = "character",
           cols = "ANY"
         ),
         prototype = list(
           location = "NA_character_",
           cols = "all"
         ))

custom_read_sav <- function(file) {
  cols <- slot(file, "cols")
  file <- slot(file, "location")
  
  if (length(cols) == 1) {
    df <- read_spss(file)
  }
  else if (is.language(cols) | is.vector(cols)){
    df <- read_spss(file, col_select = eval(cols))
  }
  else {
    stop("Weird col selection argument passed.")
  }
  
  #remove labels and such
  df <- zap_formats(zap_labels(setDT(df)))
  
  # ensure we do not return duplicates
  return(unique(df))
  
}
