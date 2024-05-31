#' Title
#'
#' @param nom_suivi
#' @param fichier_info
#' @param dossier_fiches
#' @param region
#'
#' @export
#'
#' @importFrom dplyr filter select
#' @importFrom openxlsx2 read_xlsx
creer_fiches <- function(nom_suivi, fichier_info, dossier_fiches, region = NULL) {
  infos <- openxlsx2::read_xlsx(fichier_info) %>%
    dplyr::filter(suivi == nom_suivi) %>%
    dplyr::select(-suivi) %>%
    dplyr::filter(rowSums(!is.na(.)) > 0)

  if (nrow(infos) > 0) {
    cat(nom_suivi, "\n")
    chemin_fiche_excel <- file.path(dossier_fiches, paste0(nom_suivi, ".xlsx"))
    chemin_fiche_web   <- file.path(dossier_fiches, paste0(nom_suivi, ".qmd"))

    cat("  Fiche Excel")
    creer_fiche_excel(nom_suivi, fichier_info, chemin_fiche_excel, region)
    cat(" ok\n")
    cat("  Fiche web")
    creer_fiche_web(nom_suivi, fichier_info, chemin_fiche_web, region)
    cat("  ok\n")
  }

}

#' Title
#'
#' @param fichier_info
#' @param dossier_fiches
#' @param region
#'
#' @export
#'
#' @importFrom dplyr pull
#' @importFrom openxlsx2 read_xlsx
creer_toutes_fiches <- function(fichier_info, dossier_fiches, region = NULL) {
  suivis <- fichier_info %>%
    openxlsx2::read_xlsx() %>%
    dplyr::pull(suivi)

  for (x in suivis) {
    creer_fiches(
      nom_suivi = x,
      fichier_info = fichier_info,
      dossier_fiches = dossier_fiches,
      region = region
    )
  }


}
