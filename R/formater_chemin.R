#' Format File Paths for Use in String Contexts
#'
#' This function formats file paths by doubling backslashes, which is necessary
#' when file paths are used in string contexts (like in Quarto documents, R Markdown,
#' or when passing paths to other functions that interpret backslashes as escape characters).
#' This is particularly useful when generating code that will be evaluated later or
#' when creating file paths that will be used in HTML or LaTeX documents.
#'
#' @param x A character string containing a file path with single backslashes
#'
#' @return A character string with doubled backslashes, ready to be used in string contexts
#'   where backslashes would otherwise be interpreted as escape characters
#'
#' @export
#'
#' @importFrom stringr str_replace_all
#'
#' @examples
#' # Format a Windows file path
#' # Note: In the actual code, backslashes are already escaped once for R
#' path <- "C:\\Users\\Documents\\file.txt"
#' formatted_path <- formater_chemin(path)
#' # formatted_path will be: "C:\\\\Users\\\\Documents\\\\file.txt"
#' 
#' # This is useful when creating file paths for use in generated code
#' # cat(paste0("readLines('", formatted_path, "')"))
formater_chemin <- function(x) {
  stringr::str_replace_all(
    string = x,
    pattern = "\\\\",
    replacement = "\\\\\\\\"
  )
}
