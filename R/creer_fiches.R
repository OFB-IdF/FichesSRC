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

  wb <- openxlsx2::wb_load(system.file("extdata/fiches.xlsx", package = "FichesSRC"))
  for (sheet_name in names(openxlsx2::wb_get_sheet_names(wb))[openxlsx2::wb_get_sheet_names(wb) != "modele_impression"]) {
        wb <- openxlsx2::wb_remove_worksheet(wb, sheet = sheet_name)
    }
  openxlsx2::wb_save(wb,file = "modele_fiche.xlsx", overwrite = TRUE)

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

  chemin_fiche_excel <- file.path(dossier_fiches, paste0(infos$suivi, ".xlsx"))
  chemin_fiche_web   <- file.path(dossier_fiches, paste0(infos$suivi, ".qmd"))

  creer_fiche_excel(infos, chemin_fiche_excel, region)
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

#' Create Excel Sheet for Monitoring
#'
#' This function creates an Excel sheet for monitoring purposes using a template.
#' It loads a template Excel file, fills it with information from the provided
#' monitoring data, and saves it to a specified location. The Excel sheet includes
#' various sections such as description, objectives, maps, calendars, and more.
#'
#' @param infos A list containing formatted monitoring information including title,
#'   description, objectives, roles, and other metadata. This list is typically
#'   produced by the charger_informations function.
#' @param chemin_fiche Path where the generated Excel file should be saved
#' @param region Optional. The region code to be used in the monitoring sheet.
#'   This is typically a two-digit code representing a French administrative region.
#'
#' @return No return value, called for side effects (creating Excel file)
#'
#' @export
#'
#' @importFrom openxlsx2 wb_load wb_save
#'
#' @examples
#' \dontrun{
#' # Create an Excel monitoring sheet
#' infos <- charger_informations(
#'   metadata = "https://docs.google.com/spreadsheets/d/your_sheet_id",
#'   suivi_fiche = "monitoring_name",
#'   region = "11"
#' )
#' creer_fiche_excel(
#'   infos = infos,
#'   chemin_fiche = "./output/fiches/monitoring_name.xlsx",
#'   region = "11"
#' )
#' }
creer_fiche_excel <- function(infos, chemin_fiche, region = NULL) {
  fiche <- openxlsx2::wb_load(
    file = "modele_fiche.xlsx",
    sheet = 1
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "A49",
    valeur = ifelse(infos$date_edition == "date d'édition", paste0("Editée le ", Sys.Date()), paste0("Editée le ", infos$date_edition))
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C1",
    valeur = infos$intitule
  )

  # remplir_cellule(
  #   classeur = fiche,
  #   cellule = "I6",
  #   valeur = infos$logo,
  #   largeur = 4.5,
  #   hauteur = 3.8
  # )

  remplir_cellule(
    classeur = fiche,
    cellule = "C8",
    valeur = infos$description
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C12",
    valeur = infos$objectif
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C16",
    valeur = infos$utilisation
  )

  # remplir_cellule(
  #   classeur = fiche,
  #   cellule = "B23",
  #   valeur = creer_carte(
  #     departements = infos$departements,
  #     region = region,
  #     stations = infos$fichier_stations
  #   ),
  #   largeur = 6.8,
  #   hauteur = 8
  # )

  remplir_cellule(
    classeur = fiche,
    cellule = "F24",
    valeur = infos$forme_suivi
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "B37",
    valeur = creer_calendrier(infos$mois, web = FALSE),
    largeur = 11,
    hauteur = 3
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "B45",
    valeur = infos$temporalite
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "I13",
    valeur = infos$animation
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "I31",
    valeur = infos$partenaires
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C47",
    valeur = formater_liens(infos$plus_recto1, target = "excel")
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C48",
    valeur = formater_liens(infos$plus_recto2, target = "excel")
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C49",
    valeur = formater_liens(infos$plus_recto3, target = "excel")
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M6",
    valeur = infos$duree
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "N6",
    valeur = infos$nombre_agents
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "P6",
    valeur = creer_graphe_expertise(niveau = infos$expertise),
    largeur = 5.8,
    hauteur = 1.6
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L11",
    valeur = infos$role_national
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M11",
    valeur = infos$role_regional
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "N11",
    valeur = infos$role_departemental
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "P9",
    valeur = infos$droits_formations
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L16",
    valeur = infos$protocole
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "P16",
    valeur = infos$materiel
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M29",
    valeur = infos$saisie_validation
  )

  purrr::walk(
    29:42,
    function(row_id) {
      remplir_cellule(
        classeur = fiche,
        cellule = paste0("P", row_id),
        valeur = formater_liens(infos$diffusion[[as.character(row_id)]], target = "excel")
      )
    }
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L44",
    valeur = infos$autres_releves
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M47",
    valeur = formater_liens(infos$plus_verso1, target = "excel")
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M48",
    valeur = formater_liens(infos$plus_verso2, target = "excel")
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M49",
    valeur = formater_liens(infos$plus_verso3, target = "excel")
  )

  openxlsx2::wb_save(
    wb = fiche,
    file = chemin_fiche,
    overwrite = TRUE
  )

}
