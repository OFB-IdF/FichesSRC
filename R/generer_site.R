#' @export
generer_site <- function(fichier_infos, source_fichier = c("excel", "google_sheet"), dossier_travail, region, goatcounter_id = NULL) {
  extraire_info <- function(liste_infos, info) {
    liste_infos[[info]]
  }

  if (source_fichier == "google_sheet") {
    fichier_xlsx <- file.path(dossier_travail, paste0(fichier_infos, "_gs.xlsx"))

    # Vérifier si l'authentification est nécessaire
    if (Sys.getenv("GOOGLE_SERVICE_ACCOUNT_JSON") != "") {
      # Vérifier si la fonction d'authentification existe
      if (exists("is_google_drive_auth_configured")) {
        # Si l'authentification n'est pas configurée, l'initialiser
        if (!is_google_drive_auth_configured()) {
          # Authentifier avec le compte de service
          auth_google_drive()
        }
      } else {
        # Si la fonction de vérification n'existe pas, tenter l'authentification directement
        auth_google_drive()
      }
    }

    googledrive::drive_download(
      file = fichier_infos,
      path = fichier_xlsx,
      overwrite = TRUE
    )
  } else {
    if (source_fichier == "excel") {
      fichier_xlsx <- file.path(dossier_travail, stringr::str_replace(fichier_infos, pattern = ".xlsx", replacement = "_gs.xlsx"))
      file.copy(
        from = file_infos,
        to = fichier_xlsx
      )
    } else {
      stop("source_fichier doit être 'excel' ou 'google_sheet'")
    }
  }

  liste_suivis <- charger_suivis(fichier_xlsx) |>
    dplyr::mutate(
      intitule = suivi |>
        purrr::map(
          function(suivi) {
            charger_informations(
              fichier_xlsx = fichier_xlsx,
              suivi_fiche = suivi,
              region = region,
              telecharger_fichiers = FALSE,
              dossier_travail = dossier_travail
              ) |>
              extraire_info(info = "intitule")
          }
        ) |>
        purrr::list_c()
    )

  excel_telechargeable <- creer_fiches_excel(
    suivis = liste_suivis$suivi,
    fichier_xlsx = fichier_xlsx,
    dossier = dossier_travail
  )

  creer_fiches_web(
    fichier_xlsx = fichier_xlsx,
    dossier_travail = dossier_travail,
    region = region,
    excel_telechargeable = excel_telechargeable
  )
  
  # Mettre à jour le fichier _quarto.yml avec le script GoatCounter si un ID est fourni
  if (!is.null(goatcounter_id)) {
    ajouter_goatcounter_tracking_quarto(dossier_travail, goatcounter_id)
  }

  brew::brew(
    file = system.file("extdata", "index.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "index.qmd")
  )
  brew::brew(
    file = system.file("extdata", "calendrier.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "calendrier.qmd")
  )

  if (file.exists(paste0(dossier_travail, "/", dossier_travail, ".qmd")))
    unlink(paste0(dossier_travail, "/", dossier_travail, ".qmd"))

  quarto::quarto_render(input = dossier_travail, as_job = FALSE)

  ajuster_html(dossier = file.path(dossier_travail, "_site"))

}
