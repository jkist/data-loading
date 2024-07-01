#' Get the latest sav file from a directory
#' Date: 15-06-2024
#' @author: Lisette de Schipper
#' @param mydir: A directory of choice
#' @param recursive: whether you want to include subdirs
#' @returns the latest SAV file within a directory (and, optionally, its subdirectories)

get_latest_sav_file <- function(mydir, recursive = FALSE){
  files <- list.files(path=mydir, full.names= TRUE, 
                      recursive = recursive, pattern= ".*\\.sav$")
  mtimes <- file.mtime(files)
  df <- data.frame(files, mtimes)
  df <- df[order(mtimes),]
  return(tail(df$files, 1))
}