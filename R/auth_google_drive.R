#' Configurer l'authentification Google Drive avec des variables d'environnement
#'
#' Cette fonction configure l'authentification à Google Drive en utilisant un compte de service
#' dont les informations d'identification sont fournies via des variables d'environnement.
#' Elle est particulièrement utile pour les environnements CI/CD comme GitHub Actions.
#'
#' @param env_var_name Le nom de la variable d'environnement contenant les informations d'identification
#'   du compte de service au format JSON. Par défaut "GOOGLE_SERVICE_ACCOUNT_JSON".
#'
#' @return Invisible NULL. La fonction est utilisée pour ses effets secondaires (configuration de l'authentification).
#'
#' @export
#'
#' @importFrom googledrive drive_auth
#'
#' @examples
#' \dontrun{
#' # Configurer l'authentification avec la variable d'environnement par défaut
#' auth_google_drive()
#'
#' # Configurer l'authentification avec une variable d'environnement personnalisée
#' auth_google_drive(env_var_name = "MON_COMPTE_SERVICE_GOOGLE")
#' }
auth_google_drive <- function(env_var_name = "GOOGLE_SERVICE_ACCOUNT_JSON") {
  # Vérifier si la variable d'environnement existe
  if (!env_var_name %in% names(Sys.getenv())) {
    warning("La variable d'environnement ", env_var_name, " n'est pas définie. ",
            "L'authentification à Google Drive pourrait échouer.")
    return(invisible(NULL))
  }
  
  # Récupérer le contenu JSON du compte de service
  service_account_json <- Sys.getenv(env_var_name)
  
  # Créer un fichier temporaire pour stocker les informations d'identification
  temp_json_file <- tempfile(fileext = ".json")
  on.exit(unlink(temp_json_file), add = TRUE)
  
  # Écrire le contenu JSON dans le fichier temporaire
  writeLines(service_account_json, temp_json_file)
  
  # Authentifier avec le fichier de compte de service
  googledrive::drive_auth(path = temp_json_file)
  
  invisible(NULL)
}

#' Vérifier si l'authentification Google Drive est configurée
#'
#' Cette fonction vérifie si l'authentification à Google Drive est correctement configurée
#' en tentant une opération simple (liste des fichiers).
#'
#' @return TRUE si l'authentification est configurée correctement, FALSE sinon.
#'
#' @export
#'
#' @importFrom googledrive drive_find
#'
#' @examples
#' \dontrun{
#' # Vérifier si l'authentification est configurée
#' if (is_google_drive_auth_configured()) {
#'   # Procéder aux opérations Google Drive
#' } else {
#'   # Gérer le cas où l'authentification n'est pas configurée
#' }
#' }
is_google_drive_auth_configured <- function() {
  tryCatch({
    # Tenter de lister un seul fichier pour vérifier l'authentification
    googledrive::drive_find(n_max = 1)
    TRUE
  }, error = function(e) {
    FALSE
  })
}