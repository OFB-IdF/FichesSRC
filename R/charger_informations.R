#' Charger et formater les informations depuis un fichier Excel
#'
#' Cette fonction traite les données d'un fichier Excel contenant des informations de suivi
#' et les formate en une liste structurée pour créer des fiches de suivi.
#'
#' @param fichier_xlsx Chemin vers le fichier Excel contenant les informations de suivi
#' @param suivi_fiche Le nom de la feuille de suivi à traiter
#' @param region Optionnel. Le code région à utiliser dans la sortie
#' @param telecharger_fichiers Optionnel. Indique si les fichiers associés (logo, stations) doivent être téléchargés depuis Google Drive. Par défaut TRUE
#' @param dossier_travail Optionnel. Le dossier où télécharger les fichiers associés. Par défaut le répertoire de travail courant
#'
#' @return Une liste contenant les informations de suivi formatées, incluant :
#'   \itemize{
#'     \item intitule : Le titre du suivi
#'     \item description : Description détaillée du suivi
#'     \item objectif : Objectifs du suivi
#'     \item temporalite : Aspects temporels du suivi
#'     \item role_national, role_regional, role_departemental : Rôles à différents niveaux
#'     \item Et diverses autres métadonnées de suivi
#'   }
#'
#' @export
#'
#' @importFrom dplyr filter %>%
#' @importFrom purrr set_names
#'
#' @examples
#' \dontrun{
#' # Charger les informations pour une fiche de suivi spécifique
#' infos <- charger_informations(
#'   fichier_xlsx = "chemin/vers/suivis_connaissance.xlsx",
#'   suivi_fiche = "nom_du_suivi",
#'   region = "11"
#' )
#' }
charger_informations <- function(fichier_xlsx, suivi_fiche, region, telecharger_fichiers = TRUE, dossier_travail = getwd()) {
  infos <- openxlsx2::read_xlsx(
    file = fichier_xlsx,
    sheet = suivi_fiche,
    col_names = FALSE
    )
  colnames(infos) <- LETTERS[seq_len(ncol(infos))]

  list(
    intitule = infos$C[1],
    suivi = suivi_fiche,
    logo = ifelse(
      telecharger_fichiers,
      recuperer_fichier(
        suivi_fiche,
         dossier = dossier_travail,
         patron = "logo_"
         ),
      ""),
    description = infos$C[8],
    objectif = infos$C[12],
    utilisation = infos$C[16],
    animation = infos$I[13],
    partenaires = infos$I[31],
    fichier_stations = ifelse(
      telecharger_fichiers,
      recuperer_fichier(
        suivi_fiche,
        dossier = dossier_travail,
        patron = "stations_"
        ), ""),
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
    diffusion = lapply(
      29:42,
      function(row_id) {
        if (all(!is.na(infos$P[row_id]), !is.na(infos$S[row_id])))
          list(text = infos$P[row_id], link = infos$S[row_id])
      }
    ) |>
      purrr::set_names(29:42),
    plus_recto1 = list(text = infos$C[47], link = infos$G[47]),
    plus_recto2 = list(text = infos$C[48], link = infos$G[48]),
    plus_recto3 = list(text = infos$C[49], link = infos$G[49]),
    plus_verso1 = list(text = infos$M[47], link = infos$P[47]),
    plus_verso2 = list(text = infos$M[48], link = infos$P[48]),
    plus_verso3 = list(text = infos$M[49], link = infos$P[49]),
    date_edition = infos$A[49]
  )
}

#' Charger les informations de suivi depuis un fichier Excel
#'
#' Cette fonction lit la feuille "suivis" d'un fichier Excel
#' et filtre les résultats pour n'inclure que ceux marqués comme publiables ("publiable" = "oui").
#'
#' @param fichier_xlsx Chemin vers le fichier Excel contenant les informations de suivi
#'
#' @return Un data frame contenant les informations sur les fiches de suivi publiables
#'
#' @export
#'
#' @importFrom dplyr filter
charger_suivis <- function(fichier_xlsx) {
  openxlsx2::read_xlsx(file = fichier_xlsx, sheet = "suivis") |>
    dplyr::filter(publiable == "oui")
}

#' Récupérer un fichier associé à une fiche de suivi
#'
#' Cette fonction recherche et télécharge un fichier associé à une fiche de suivi spécifique
#' depuis Google Drive. Elle recherche les fichiers avec le modèle "[patron][suivi]".
#'
#' @param suivi Le nom de la fiche de suivi pour laquelle récupérer le fichier associé
#' @param dossier Optionnel. Le répertoire où le fichier doit être téléchargé.
#'   Par défaut, le répertoire de travail courant
#' @param patron Le préfixe du fichier à rechercher (ex: "logo_", "stations_")
#'
#' @return Le chemin vers le fichier téléchargé. Si aucun fichier n'est trouvé,
#'   retourne le chemin où le fichier aurait été téléchargé.
#'
#' @importFrom googledrive drive_find drive_download
#' @importFrom dplyr pull
#'
#' @keywords internal
recuperer_fichier <- function(suivi, dossier = getwd(), patron) {
  fichier <- googledrive::drive_find(pattern = paste0(patron, suivi)) |>
    dplyr::pull(name)

  if (length(fichier) > 0) {
    googledrive::drive_download(file = fichier, path = file.path(dossier, fichier), overwrite = TRUE)
  }
  return(fichier)
}
