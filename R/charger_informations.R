#' Title
#'
#' @param fichier_info
#' @param nom_suivi
#'
#' @return
#' @export
#'
charger_informations <- function(fichier_info, nom_suivi = NULL) {
  infos <- openxlsx2::read_xlsx(file = fichier_info, keep_attributes = TRUE)

  if (!is.null(nom_suivi)) {
    infos %>%
      dplyr::filter(suivi == nom_suivi)
  } else {
    infos
  }
}

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
formater_liens <- function(x) {
  if (!is.na(x) & stringr::str_detect(string = x, pattern = "lien:")) {
    texte <- stringr::str_split_1(x, pattern = ";")[1] %>%
    stringr::str_remove(pattern = "texte:") %>%
    stringr::str_trim()
  lien <- stringr::str_split_1(x, pattern = ";")[2] %>%
    stringr::str_remove(pattern = "lien:") %>%
    stringr::str_trim()

  openxlsx2::create_hyperlink(text = texte, file = lien)
  } else {
    x
  }

}
