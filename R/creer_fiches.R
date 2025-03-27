#' Create All Monitoring Sheets from a Google Sheet
#'
#' This function reads a Google Sheet containing monitoring information and creates
#' web-based monitoring sheets for all entries marked as publishable ("publiable" = "oui").
#' It processes each monitoring entry and generates both Excel and web (Quarto) versions
#' of the monitoring sheets.
#'
#' @param metadata URL or ID of the Google Sheet containing monitoring information.
#'   This sheet should have a "suivis" tab with a column "publiable" to filter publishable entries.
#' @param dossier_fiches Directory path where the generated monitoring sheets will be saved.
#'   Both Excel (.xlsx) and Quarto (.qmd) files will be created in this directory.
#' @param region Optional. The region code to be used in the monitoring sheets.
#'   This is typically a two-digit code representing a French administrative region.
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom dplyr pull
#' @importFrom googlesheets4 read_sheet
#'
#' @examples
#' \dontrun{
#' # Create all monitoring sheets and save them to a directory
#' creer_toutes_fiches(
#'   metadata = "https://docs.google.com/spreadsheets/d/your_sheet_id",
#'   dossier_fiches = "./output/fiches",
#'   region = "11"
#' )
#' }
creer_toutes_fiches <- function(metadata, dossier_fiches, region = NULL) {
  suivis <- charger_suivis(metadata)

  creer_fiches_excel(suivis = suivis, chemin_fiches = file.path(dossier_fiches, "suivis_connaissance.xlsx"))

  for (x in suivis$suivi) {
    creer_fiches(
      infos = charger_informations(metadata, suivi = x, region = region),
      dossier_fiches = dossier_fiches,
      region = region
    )
  }
}


#' Create a Single Monitoring Sheet
#'
#' This function creates both web-based (Quarto) and Excel monitoring sheets for a specific
#' monitoring entry using the provided information. It calls the specialized functions
#' creer_fiche_web and creer_fiche_excel to generate each format.
#'
#' @param infos A list containing formatted monitoring information including title,
#'   description, objectives, roles, and other metadata. This list is typically
#'   produced by the charger_informations function.
#' @param dossier_fiches Directory path where the generated monitoring sheets will be saved.
#'   Both Excel (.xlsx) and Quarto (.qmd) files will be created in this directory.
#' @param region Optional. The region code to be used in the monitoring sheets.
#'   This is typically a two-digit code representing a French administrative region.
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom dplyr filter select
#' @importFrom googlesheets4 read_sheet
#'
#' @examples
#' \dontrun{
#' # Create monitoring sheets for a specific monitoring entry
#' infos <- charger_informations(
#'   metadata = "https://docs.google.com/spreadsheets/d/your_sheet_id",
#'   suivi_fiche = "monitoring_name",
#'   region = "11"
#' )
#' creer_fiches(
#'   infos = infos,
#'   dossier_fiches = "./output/fiches",
#'   region = "11"
#' )
#' }
creer_fiches <- function(infos, dossier_fiches, region = NULL) {
  cat(infos$suivi)

  chemin_fiche_web   <- file.path(dossier_fiches, paste0(infos$suivi, ".qmd"))
  creer_fiche_web(infos, chemin_fiche_web, region)
  cat("  ✓\n")
}

#' Create a Web-Based Monitoring Sheet
#'
#' This function generates a web-based monitoring sheet (Quarto document) using a template
#' and the provided monitoring information. It uses the brew package to process a template
#' file and insert the monitoring information at the appropriate locations.
#'
#' @param infos A list containing formatted monitoring information including title,
#'   description, objectives, roles, and other metadata. This list is typically
#'   produced by the charger_informations function and should contain elements like
#'   intitule, description, objectif, etc.
#' @param chemin_fiche The file path where the generated Quarto (.qmd) document will be saved.
#'   This file can then be rendered to HTML using Quarto.
#' @param region Optional. The region code to be used in the monitoring sheet.
#'   This is typically a two-digit code representing a French administrative region.
#'
#' @return No return value, called for side effects (file creation)
#'
#' @export
#'
#' @importFrom brew brew
#'
#' @examples
#' \dontrun{
#' # Create a web-based monitoring sheet
#' infos <- charger_informations(
#'   metadata = "https://docs.google.com/spreadsheets/d/your_sheet_id",
#'   suivi_fiche = "monitoring_name",
#'   region = "11"
#' )
#' creer_fiche_web(
#'   infos = infos,
#'   chemin_fiche = "./output/fiches/monitoring_name.qmd",
#'   region = "11"
#' )
#' }
creer_fiche_web <- function(infos, chemin_fiche, region = NULL) {
  brew::brew(
    system.file("extdata", "page.qmd.brew", package = "FichesSRC"),
    chemin_fiche
  )
}
