#' Title
#'
#' @param dossier
#'
#' @return
#' @export
#'
#' @examples
ajuster_html <- function(dossier) {
  list.files(dossier, pattern = ".html", full.names = TRUE) %>%
    purrr::walk(
      .f = function(path) {
        readLines(path) %>%
          stringr::str_replace(
            pattern = '<a href="./index.html" class="navbar-brand navbar-brand-logo">',
            replacement = '<a href="https://www.ofb.gouv.fr" class="navbar-brand navbar-brand-logo">'
          ) %>%
          stringr::str_replace(
            pattern = '<a class="navbar-brand" href="./index.html">',
            replacement = '<a class="navbar-brand">'
          ) %>%
          (function(html_content) {
            target_line <- '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link active" data-scroll-target="#le-suivi">Le suivi</a>'
            new_lines <- c(
              '<li><a href="#description" id="toc-description" class="nav-link active" data-scroll-target="#description">Description</a>',
              '<ul class="collapse">',
              '<li><a href="#objectif" id="toc-objectif" class="nav-link" data-scroll-target="#objectif">Objectif</a></li>',
              '<li><a href="#utilisation" id="toc-utilisation" class="nav-link" data-scroll-target="#utilisation">Utilisation</a></li>',
              '</ul></li>',
              '<li><a href="#animation" id="toc-animation" class="nav-link" data-scroll-target="#animation">Animation</a></li>'
            )

            # Trouver l'index de la ligne cible
            target_index <- stringr::str_which(html_content, stringr::fixed(target_line))

            # Insérer les nouvelles lignes avant la ligne cible
            if(length(target_index) > 0) {
              html_content <- append(html_content, new_lines, after = target_index - 1)
            }

            html_content

          }) %>%
          stringr::str_replace(
            pattern = '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link active" data-scroll-target="#le-suivi">Le suivi</a>',
            replacement = '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link" data-scroll-target="#le-suivi">Le suivi</a>'
          ) %>%
          writeLines(path)
      }
    )

}
