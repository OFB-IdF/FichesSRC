#' Récupérer le fichier suivis_connaissance.xlsx du package
#'
#' Cette fonction récupère le fichier suivis_connaissance.xlsx disponible dans le dossier extdata
#' du package FichesSRC et le copie vers un emplacement spécifié par l'utilisateur.
#' Si aucun emplacement n'est spécifié, l'utilisateur sera invité à choisir
#' l'emplacement de manière interactive.
#'
#' @param chemin_destination Optionnel. Le chemin où copier le fichier suivis_connaisance.xlsx.
#'   Si NULL (par défaut), une boîte de dialogue s'ouvrira pour permettre à l'utilisateur
#'   de choisir l'emplacement de manière interactive.
#'
#' @return Le chemin vers le fichier copié (invisible).
#'
#' @export
#'
#' @importFrom utils file.choose
#'
#' @examples
#' \dontrun{
#' # Copier le fichier vers un emplacement spécifique
#' recuperer_fiches_excel("C:/Users/utilisateur/Documents/suivis_connaissance.xlsx")
#'
#' # Ouvrir une boîte de dialogue pour choisir l'emplacement
#' recuperer_fiches_excel()
#' }
recuperer_fiches_excel <- function(chemin_destination = NULL) {
  # Localiser le fichier fiches.xlsx dans le dossier extdata du package
  fichier_source <- system.file("extdata", "suivis_connaissance.xlsx", package = "FichesSRC")
  
  if (fichier_source == "") {
    stop("Le fichier 'suivis_connaissance.xlsx' n'a pas été trouvé dans le dossier extdata du package FichesSRC.")
  }
  
  # Si aucun chemin de destination n'est spécifié, demander à l'utilisateur
  if (is.null(chemin_destination)) {
    message("Veuillez choisir l'emplacement où enregistrer le fichier suivis_connaissance.xlsx...")
    chemin_destination <- file.choose(new = TRUE)
  }
  
  # Vérifier si le dossier parent existe, sinon le créer
  dossier_parent <- dirname(chemin_destination)
  if (!dir.exists(dossier_parent)) {
    dir.create(dossier_parent, recursive = TRUE)
  }
  
  # Copier le fichier
  resultat_copie <- file.copy(from = fichier_source, to = chemin_destination, overwrite = TRUE)
  
  if (resultat_copie) {
    message("Le fichier suivis_connaissance.xlsx a été copié avec succès vers : ", chemin_destination)
  } else {
    stop("Échec de la copie du fichier suivis_connaissance.xlsx vers : ", chemin_destination)
  }
  
  # Retourner le chemin de destination de manière invisible
  invisible(chemin_destination)
}