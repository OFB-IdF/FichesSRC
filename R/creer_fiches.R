#' Créer toutes les fiches de suivi web à partir d'un fichier Excel
#'
#' Cette fonction lit un fichier Excel contenant des informations de suivi et crée
#' des fiches de suivi web pour toutes les entrées marquées comme publiables ("publiable" = "oui").
#' Elle traite chaque entrée de suivi et génère des versions web (Quarto) des fiches de suivi.
#'
#' @param fichier_xlsx Chemin vers le fichier Excel contenant les informations de suivi.
#'   Ce fichier doit avoir un onglet "suivis" avec une colonne "publiable" pour filtrer les entrées publiables.
#' @param dossier_travail Chemin du répertoire où les fiches de suivi générées seront enregistrées.
#'   Les fichiers Quarto (.qmd) seront créés dans ce répertoire.
#' @param region Optionnel. Le code région à utiliser dans les fiches de suivi.
#'   Il s'agit généralement d'un code à deux chiffres représentant une région administrative française.
#' @param excel_telechargeable Indique si un lien vers le fichier Excel téléchargeable doit être inclus dans les fiches web.
#'
#' @return Aucune valeur de retour, appelée pour ses effets secondaires (création de fichiers)
#'
#' @export
#'
#' @importFrom dplyr pull
#'
#' @examples
#' \dontrun{
#' # Créer toutes les fiches de suivi et les enregistrer dans un répertoire
#' creer_fiches_web(
#'   fichier_xlsx = "chemin/vers/suivis_connaissance.xlsx",
#'   dossier_fiches = "./output/fiches",
#'   region = "11",
#'   excel_telechargeable = TRUE
#' )
#' }
creer_fiches_web <- function(fichier_xlsx, dossier_travail, region = NULL, excel_telechargeable) {
  suivis <- charger_suivis(fichier_xlsx)$suivi

  for (suivi in suivis) {
    infos <- charger_informations(fichier_xlsx, suivi = suivi, region = region, dossier_travail = dossier_travail)
    excel_telechargeable <- excel_telechargeable

    brew::brew(
      system.file("extdata", "page.qmd.brew", package = "FichesSRC"),
      file.path(dossier_travail, paste0(infos$suivi, ".qmd"))
    )

    cat(suivi, "  ✓\n")
  }

  pages_site <- list.files(path = dossier_travail, pattern = ".qmd")
  unlink(file.path(dossier_travail, pages_site)[!pages_site %in% paste0(c(suivis, "index", "calendrier", "productions", "ressources"), ".qmd")])

}
