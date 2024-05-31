#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
formater_chemin <- function(x) {
  stringr::str_replace_all(
    string = x,
    pattern = "\\\\",
    replacement = "\\\\\\\\"
    )

}
