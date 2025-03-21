#' Create a web-based monitoring sheet
#'
#' This function generates a web-based monitoring sheet (Quarto document) using a template
#' and the provided monitoring information.
#'
#' @param infos A list containing formatted monitoring information including title,
#'   description, objectives, roles, and other metadata
#' @param chemin_fiche The file path where the generated web sheet will be saved
#' @param region Optional. The region code to be used in the monitoring sheet
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom brew brew
creer_fiche_web <- function(infos, chemin_fiche, region = NULL) {
  brew::brew(
    system.file("extdata", "page.qmd.brew", package = "FichesSRC"),
    chemin_fiche
  )

}
