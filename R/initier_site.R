#' Initialiser un site Quarto pour les fiches SRC
#'
#' Cette fonction initialise un nouveau site Quarto pour les fiches SRC en créant
#' la structure de base du projet, en copiant les fichiers nécessaires et en
#' générant les pages principales du site.
#'
#' @param dossier_travail Chemin du dossier où le site sera créé
#' @param goatcounter_id Identifiant GoatCounter pour le suivi des statistiques du site (optionnel)
#'
#' @return Aucune valeur de retour, fonction appelée pour ses effets secondaires (création de fichiers)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Initialiser un site dans le dossier courant
#' initier_site(getwd())
#'
#' # Initialiser un site avec suivi GoatCounter
#' initier_site("./mon_site", goatcounter_id = "mon_identifiant")
#' }
initier_site <- function(dossier_travail, goatcounter_id = NULL) {
  if (!quarto::is_using_quarto(dossier_travail)) {
    quarto::quarto_create_project(name = dossier_travail)

    copier_www(dossier_travail)

    # Copier le fichier _quarto.yml
    file.copy(
      from = system.file("extdata", "_quarto.yml", package = "FichesSRC"),
      to = file.path(dossier_travail, "_quarto.yml"),
      overwrite = TRUE
    )
    
    # Ajouter le script GoatCounter au _quarto.yml si un ID est fourni
    if (!is.null(goatcounter_id)) {
      ajouter_goatcounter_tracking_quarto(dossier_travail, goatcounter_id)
    }
    
    file.copy(
      from = system.file("extdata", "robots.txt", package = "FichesSRC"),
      to = file.path(dossier_travail, "robots.txt"),
      overwrite = TRUE
    )

    brew::brew(
      file = system.file("extdata", "productions.qmd.template", package = "FichesSRC"),
      output = file.path(dossier_travail, "productions.qmd")
    )
    brew::brew(
      file = system.file("extdata", "ressources.qmd.template", package = "FichesSRC"),
      output = file.path(dossier_travail, "ressources.qmd")
    )
  } else {
    cat("Initialisation non nécessaire")
  }
}
