#' Title
#'
#' @param x
#'
#' @export
#'
#' @importFrom stringr str_extract str_replace_all str_starts str_detect
formater_web <- function(x) {
  expression_liens <- "(http|ftp|https)://[\\w_-]+(\\.[\\w_-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?|www\\.[\\w_-]+(\\.[\\w_-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?"
  expression_mail <- "([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})"
  expression_gras <- "Animation nationale|Animation régionale|Suivi scientifique"

  convertir_en_lien <- function(chaine) {

      # Extraire le texte et le lien
      texte <- stringr::str_extract(chaine, "(?<=texte:)(.*)(?=;\\s*lien)")
      lien <- stringr::str_extract(chaine, "(?<=lien:)(.*)")

      # Créer le format de lien
      lien <- stringr::str_replace_all(
        string = lien,
        pattern = expression_liens,
        replacement = function(match) {
          if (stringr::str_starts(match, "www")) {
            paste0("http://", match)
          } else {
            match
          }
        }
      )

      paste0('<a href="', lien, '">', texte, '</a>')

  }


  if (!is.na(x)) {
    if (stringr::str_detect(string = x, pattern = "(?<=texte:)(.*)(?=;\\s*lien)")) {
      convertir_en_lien(x)
    } else {
      x %>%
        stringr::str_replace_all(pattern = "\n", replacement = "<br>") %>%
        stringr::str_replace_all(pattern = "^-", replacement = "<br>-") %>%
        stringr::str_replace_all(
          pattern = expression_liens,
          replacement = function(match) {
            if (stringr::str_starts(match, "www")) {
              paste0("<a href='http://", match, "'>", match, "</a>")
            } else {
              paste0("<a href='", match, "'>", match, "</a>")
            }
          }
        ) %>%
        stringr::str_replace_all(
          pattern = expression_mail,
          replacement = "<a href='mailto:\\1'>\\1</a>"
        ) %>%
        stringr::str_replace_all(
          pattern = expression_gras,
          replacement = "<b>\\0</b>"
        )
    }
  } else {
    NULL
  }

}
