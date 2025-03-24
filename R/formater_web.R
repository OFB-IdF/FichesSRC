#' Format Text for Web Display
#'
#' This function formats text for web display by converting special text patterns into HTML.
#' It handles hyperlinks, email addresses, and specific keywords that need to be emphasized.
#' The function recognizes text in the format "texte:displayed text;lien:url" and converts it
#' into proper HTML anchor tags.
#'
#' @param x A character string to be formatted. Can contain special patterns like
#'          "texte:displayed text;lien:url" for links, email addresses, or keywords
#'          that need special formatting.
#'
#' @return A character string with HTML formatting applied. Links are converted to
#'         <a> tags, newlines to <br> tags, and certain keywords are emphasized.
#'         Returns NA if input is NA.
#'
#' @examples
#' # Format a simple link
#' formater_web("texte:Visit our site;lien:https://example.com")
#'
#' # Format text with newlines
#' formater_web("Line 1\nLine 2")
#'
#' @export
#'
#' @importFrom stringr str_extract str_replace_all str_starts str_detect
formater_web <- function(x) {
  expression_liens <- "(http|ftp|https)://[\\w_-]+(\\.[\\w_-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?|www\\.[\\w_-]+(\\.[\\w_-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?"
  expression_mail <- "([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})"
  expression_gras <- "Animation nationale|Animation régionale|Suivi scientifique|Correspondants départementaux|Référence technique|Assistance|Courriel du réseau"

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
      x |>
        stringr::str_replace_all(pattern = "\n", replacement = "<br>") |>
        stringr::str_replace_all(pattern = "^-", replacement = "<br>-") |>
        stringr::str_replace_all(
          pattern = expression_liens,
          replacement = function(match) {
            if (stringr::str_starts(match, "www")) {
              paste0("<a href='http://", match, "'>", match, "</a>")
            } else {
              paste0("<a href='", match, "'>", match, "</a>")
            }
          }
        ) |>
        stringr::str_replace_all(
          pattern = expression_mail,
          replacement = "<a href='mailto:\\1'>\\1</a>"
        ) |>
        stringr::str_replace_all(
          pattern = expression_gras,
          replacement = "<b>\\0</b>"
        )
    }
  } else {
    NULL
  }

}
