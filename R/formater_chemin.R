#' Format File Paths for Use in String Contexts
#'
#' This function formats file paths by doubling backslashes, which is necessary
#' when file paths are used in string contexts (like in Quarto documents or when
#' passing paths to other functions that interpret backslashes as escape characters).
#'
#' @param x A character string containing a file path with single backslashes
#'
#' @return A character string with doubled backslashes
#'
#' @export
#'
#' @importFrom stringr str_replace_all
#'
#' @examples
#' # Format a Windows file path
#' formater_chemin("C:\\Users\\Documents\\file.txt")
#' # Returns: "C:\\\\Users\\\\Documents\\\\file.txt"
formater_chemin <- function(x) {
  stringr::str_replace_all(
    string = x,
    pattern = "\\\\",
    replacement = "\\\\\\\\"
  )
}
