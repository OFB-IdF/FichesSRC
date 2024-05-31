#' Title
#'
#' @param nom_suivi
#' @param fichier_info
#' @param dossier_fiches
#' @param region
#'
#' @return
#' @export
#'
#' @examples
creer_fiches <- function(nom_suivi, fichier_info, dossier_fiches, region = NULL) {
  chemin_fiche_excel <- file.path(dossier_fiches, paste0(nom_suivi, ".xlsx"))
  chemin_fiche_web   <- file.path(dossier_fiches, paste0(nom_suivi, ".qmd"))

  creer_fiche_excel(nom_suivi, fichier_info, chemin_fiche_excel, region)
  creer_fiche_web(nom_suivi, fichier_info, chemin_fiche_web, region)
}
