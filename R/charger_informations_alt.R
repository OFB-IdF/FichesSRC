#' Load and format information from a Google Sheet
#'
#' This function processes data from a Google Sheet containing monitoring information
#' and formats it into a structured list for use in creating monitoring sheets.
#'
#' @param metadata Link or ID of a Google Sheet document
#' @param suivi_fiche The name of the monitoring sheet being processed
#' @param region Optional. The region code to be used in the output
#'
#' @return A list containing formatted monitoring information including:
#'   \itemize{
#'     \item intitule: The title of the monitoring
#'     \item description: Detailed description of the monitoring
#'     \item objectif: Objectives of the monitoring
#'     \item temporalite: Temporal aspects of the monitoring
#'     \item role_national, role_regional, role_departemental: Roles at different levels
#'     \item And various other monitoring metadata
#'   }
#'
#' @export
#'
#' @importFrom dplyr filter %>%
charger_informations <- function(metadata, suivi_fiche, region) {
  infos <- googlesheets4::read_sheet(metadata, sheet = suivi_fiche, col_names = FALSE, col_types = "c")
  colnames(infos) <- LETTERS[seq_len(ncol(infos))]
  list(
    intitule = infos$C[1],
    suivi = suivi_fiche,
    logo = recuperer_logo(suivi_fiche, dossier = "logos"),
    description = infos$C[8],
    objectif = infos$C[12],
    utilisation = infos$C[16],
    animation = infos$I[13],
    partenaires = infos$I[31],
    fichier_stations = recuperer_stations(suivi_fiche, dossier = "stations"),
    departements = infos$C[22],
    region = region,
    forme_suivi = infos$F[24],
    temporalite = infos$B[45],
    mois = formater_mois(infos[37:44, c("B", "C", "D", "E", "F", "G", "H")]),
    role_national = infos$L[11],
    role_regional = infos$M[11],
    role_departemental = infos$N[11],
    duree = infos$M[6],
    nombre_agents = infos$N[6],
    expertise = infos[7, c("P", "Q", "R", "S", "T")][!is.na(infos[6, c("P", "Q", "R", "S", "T")])],
    droits_formation = infos$P[9],
    protocole = infos$L[16],
    materiel = infos$P[16],
    autres_releves = infos$M[43],
    saisie_validation = infos$M[29],
    diffusion = paste(
      na.omit(c(
        infos$P[29],
        infos$P[32],
        infos$P[35],
        infos$P[37]
      )),
      collapse = "\n"
    ), #PROBLEME: ne récupère pas les liens, seulement le texte
    plus_recto1 = list(text = infos$C[47], link = infos$G[47]),
    plus_recto2 = list(text = infos$C[48], link = infos$G[48]),
    plus_recto3 = list(text = infos$C[49], link = infos$G[49]),
    plus_verso1 = list(text = infos$M[47], link = infos$P[47]),
    plus_verso2 = list(text = infos$M[48], link = infos$P[48]),
    plus_verso3 = list(text = infos$M[49], link = infos$P[49])
  )
}

#' Load monitoring information from a Google Sheet
#'
#' This function reads the "suivis" sheet from a Google Sheet document
#' and filters the results to include only those marked as publishable ("publiable" = "oui").
#'
#' @param metadata Link or ID of a Google Sheet document
#'
#' @return A data frame containing information about publishable monitoring sheets
#'
#' @export
#'
#' @importFrom dplyr filter
#' @importFrom googlesheets4 read_sheet
charger_suivis <- function(metadata) {
  googlesheets4::read_sheet(metadata, sheet = "suivis") |>
    dplyr::filter(publiable == "oui")
}

#' Retrieve Logo for a Monitoring Sheet
#'
#' This function searches for and downloads a logo file associated with a specific monitoring
#' sheet from Google Drive. It looks for files with the pattern "logo_[suivi]".
#'
#' @param suivi The name of the monitoring sheet for which to retrieve the logo
#' @param dossier Optional. The directory where the logo file should be downloaded.
#'   Defaults to the current working directory
#'
#' @return The file path to the downloaded logo file
#'
#' @importFrom googledrive drive_find drive_download
#' @importFrom dplyr pull
recuperer_logo <- function(suivi, dossier = getwd()) {
  fichier <- googledrive::drive_find(pattern = paste0("logo_", suivi)) |>
    dplyr::pull(name)

  if (!dir.exists(dossier))
    dir.create(dossier)

  if (length(fichier) > 0)
    googledrive::drive_download(file = fichier, path = file.path(dossier, fichier), overwrite = TRUE)

  return(file.path(dossier, fichier))
}

#' Retrieve Stations Data for a Monitoring Sheet
#'
#' This function searches for and downloads a stations data file associated with a specific
#' monitoring sheet from Google Drive. It looks for files with the pattern "stations_[suivi]".
#'
#' @param suivi The name of the monitoring sheet for which to retrieve the stations data
#' @param dossier Optional. The directory where the stations file should be downloaded.
#'   Defaults to the current working directory
#'
#' @return The file path to the downloaded stations data file
#'
#' @importFrom googledrive drive_find drive_download
#' @importFrom dplyr pull
recuperer_stations <- function(suivi, dossier = getwd()) {
  fichier <- googledrive::drive_find(pattern = paste0("stations_", suivi)) |>
    dplyr::pull(name)

  if (!dir.exists(dossier))
    dir.create(dossier)

  if (length(fichier) > 0)
    googledrive::drive_download(file = fichier, path = file.path(dossier, fichier), overwrite = TRUE)

  return(file.path(dossier, fichier))
}
