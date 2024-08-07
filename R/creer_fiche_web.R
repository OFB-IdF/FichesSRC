#' Title
#'
#' @param nom_suivi
#' @param fichier_info
#' @param chemin_fiche
#' @param region
#'
#' @export
#'
#' @importFrom brew brew
creer_fiche_web <- function(nom_suivi, fichier_info, chemin_fiche, region = NULL) {
  infos <- charger_informations(fichier_info, nom_suivi) %>%
    c(region = region)

  brew::brew(
    system.file("extdata", "page.qmd.brew", package = "FichesSRC"),
    chemin_fiche
  )

}
