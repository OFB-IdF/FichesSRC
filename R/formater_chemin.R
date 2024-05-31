#' Title
#'
#' @param x
#'
#' @export
#'
#' @importFrom stringr str_replace_all
formater_chemin <- function(x) {
  stringr::str_replace_all(
    string = x,
    pattern = "\\\\",
    replacement = "\\\\\\\\"
    )

}
