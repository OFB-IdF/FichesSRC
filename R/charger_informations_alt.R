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
  infos <- googlesheets4::read_sheet(metadata, sheet = suivi_fiche, col_names = FALSE)
  colnames(infos) <- LETTERS[seq_len(ncol(infos))]
  list(
    intitule = infos$C[1],
    suivi = suivi_fiche,
    logo = infos$I[6],
    description = infos$C[8],
    objectif = infos$C[12],
    utilisation = infos$C[16],
    animation = infos$I[13],
    partenaires = infos$I[31],
    fichier_stations = charger_suivis(metadata) |>
      janitor::clean_names() |>
      dplyr::filter(suivi == suivi_fiche) |>
      dplyr::pull(fichier_station),
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
