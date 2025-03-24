#' Adjust HTML Files for Web Display
#'
#' This function processes HTML files in a directory to adjust navigation links and structure.
#' It modifies navbar links, updates the table of contents structure, and customizes the navigation
#' for a better web presentation.
#'
#' @param dossier Path to the directory containing HTML files to be adjusted
#'
#' @return No return value, called for side effects (modifying HTML files)
#' @export
#'
#' @importFrom purrr walk
#' @importFrom stringr str_replace str_which fixed
#'
#' @examples
#' # Adjust HTML files in the current directory
#' ajuster_html("./")
#'
#' # Adjust HTML files in a specific output directory
#' ajuster_html("./output/html/")
ajuster_html <- function(dossier) {
  list.files(dossier, pattern = ".html", full.names = TRUE) |>
  purrr::walk(
    .f = function(path) {
      readLines(path) |>
        stringr::str_replace(
          pattern = '<a href="./index.html" class="navbar-brand navbar-brand-logo">',
          replacement = '<a href="https://www.ofb.gouv.fr" class="navbar-brand navbar-brand-logo">'
        ) |>
        stringr::str_replace(
          pattern = '<a class="navbar-brand" href="./index.html">',
          replacement = '<a class="navbar-brand">'
        ) |>
        modifier_toc() |>
        stringr::str_replace(
          pattern = '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link active" data-scroll-target="#le-suivi">Le suivi</a>',
          replacement = '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link" data-scroll-target="#le-suivi">Le suivi</a>'
        ) |>
        writeLines(path)
    }
  )

}
