#' Copier les images du package vers un dossier spécifié
#'
#' Cette fonction copie tous les fichiers PNG du dossier 'www' du package FichesSRC
#' vers un dossier spécifié par l'utilisateur. Ces images sont utilisées pour
#' l'affichage et la mise en forme des fiches de suivi.
#'
#' @param dossier Chemin du dossier de destination où les images seront copiées
#'
#' @return Aucune valeur de retour, fonction appelée pour ses effets secondaires (copie de fichiers)
#'
#' @export
#'
#' @importFrom purrr walk
#'
#' @examples
#' \dontrun{
#' # Copier les images vers le dossier courant
#' copier_images(getwd())
#'
#' # Copier les images vers un dossier spécifique
#' copier_images("./output/images")
#' }
copier_www <- function(dossier) {
  if (!dir.exists(file.path(dossier, "www")))
    dir.create(file.path(dossier, "www"))

  purrr::walk(
    list.files(system.file("www", package = "FichesSRC"), full.names = TRUE),
    function(x) {
      file.copy(
        from = x,
        to = file.path(dossier, "www", basename(x)),
        overwrite = TRUE
      )
    }
  )

}
