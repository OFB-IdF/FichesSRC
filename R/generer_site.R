#' @export
generer_site <- function(fichier_infos, source_fichier = c("excel", "google_sheet"), dossier_travail, region, goatcounter_id = NULL) {
  if(!dir.exists(dossier_travail))
    dir.create(dossier_travail)

  if (!quarto::is_using_quarto(dossier_travail))
    quarto::quarto_create_project(name = dossier_travail)

  extraire_info <- function(liste_infos, info) {
    liste_infos[[info]]
  }

  if (!dir.exists(dossier_travail)) {
    initier_site(dossier_travail)
  }

  copier_www(dossier_travail)
  file.copy(
    from = system.file("extdata", "_quarto.yml", package = "FichesSRC"),
    to = file.path(dossier_travail, "_quarto.yml"),
    overwrite = TRUE
    )

  if (source_fichier == "google_sheet") {
    fichier_xlsx <- file.path(dossier_travail, paste0(fichier_infos, "_gs.xlsx"))

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
    dossier_fiches = dossier_travail,
    region = region,
    excel_telechargeable = excel_telechargeable
  )

  ajouter_goatcounter_tracking(
    dossier_travail = dossier_travail,
    suivis = liste_suivis$suivi,
    goatcounter_id = goatcounter_id
  )

  brew::brew(
    file = system.file("extdata", "index.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "index.qmd")
  )
  brew::brew(
    file = system.file("extdata", "calendrier.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "calendrier.qmd")
  )
  brew::brew(
    file = system.file("extdata", "productions.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "productions.qmd")
  )
  brew::brew(
    file = system.file("extdata", "ressources.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "ressources.qmd")
  )
  if (file.exists(paste0(dossier_travail, "/", dossier_travail, ".qmd")))
    unlink(paste0(dossier_travail, "/", dossier_travail, ".qmd"))

  quarto::quarto_render(input = dossier_travail)

  ajuster_html(dossier = file.path(dossier_travail, "_site"))

}
