#' Get the latest sav files from all subdirectories of directories of choice
#' This is based on the assumption that all subdirectories have the year as the directory name
#' Date: 19-06-2024
#' @author Lisette de Schipper
#' @param mydirs One or multiple directories of choice
#' @param blacklist one word or a vector of words that are not allowed to be in the file names
#' @returns the latest SAV file within all subdirectories of a directory
#' @example
#' get_latest_sav_files(c(r"(G:\InkomenBestedingen\INTEGRAAL HUISHOUDENS INKOMEN)", 
#' r"(G:\InkomenBestedingen\INHATAB)"), c("KOPPELPERSOON", "INHA"))

get_latest_sav_files <- function(mydirs, blacklist){
  file <- unlist(lapply(mydirs, list.files, full.names=TRUE, 
                           recursive = TRUE, pattern= ".*\\.sav$"))
  
  # legady code. Left it in as a fall back.
  # year <- sapply(strsplit(file, "/"), function(x) as.integer(x[2]))
  
  if (!missing(blacklist))
  {
    if (is.vector(blacklist)){
      blacklist <- paste(blacklist, collapse = "|")
    }
    file <- Filter(function(x) !any(grep(blacklist, x)), file)
  }
  
  #this will match with the first 4 digit substring
  year <-  as.integer(unlist(regmatches(file, regexpr("[0-9]{4}", file))))
  
  mtime <- file.mtime(file)
  df <- data.frame(year, file, mtime)
  df <- df[order(year, mtime),]
  df <- df[!duplicated(df$year, fromLast = TRUE),]
  row.names(df) <- NULL
  return(df[,c("year", "file")])
}