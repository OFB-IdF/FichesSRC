#' Create all monitoring sheets from a Google Sheet
#'
#' This function reads a Google Sheet containing monitoring information and creates
#' web-based monitoring sheets for all entries marked as publishable.
#'
#' @param fichier_info URL or ID of the Google Sheet containing monitoring information
#' @param dossier_fiches Directory path where the generated monitoring sheets will be saved
#' @param region Optional. The region code to be used in the monitoring sheets
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom dplyr pull
#' @importFrom googlesheets4 read_sheet
creer_toutes_fiches <- function(fichier_info, dossier_fiches, region = NULL) {
  suivis <- googlesheets4::read_sheet(fichier_info, sheet = "index") |>
    dplyr::filter(publiable == "oui") |>
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


#' Create a single monitoring sheet
#'
#' This function creates a web-based monitoring sheet for a specific monitoring entry
#' from a Google Sheet source.
#'
#' @param nom_suivi Name of the monitoring sheet to create
#' @param fichier_info URL or ID of the Google Sheet containing monitoring information
#' @param dossier_fiches Directory path where the generated monitoring sheet will be saved
#' @param region Optional. The region code to be used in the monitoring sheet
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom dplyr filter select
#' @importFrom googlesheets4 read_sheet
creer_fiches <- function(nom_suivi, fichier_info, dossier_fiches, region = NULL) {
  cat(nom_suivi)
  infos <- googlesheets4::read_sheet(fichier_info, sheet = nom_suivi, col_names = FALSE) |>
    charger_informations(suivi = nom_suivi, region = region)

  if (nrow(infos) > 0) {
    chemin_fiche_web   <- file.path(dossier_fiches, paste0(nom_suivi, ".qmd"))

    creer_fiche_web(infos, chemin_fiche_web, region)
    cat("  ✓\n")
  } else {
    cat("  ×\n")
  }
}

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
