#' Load Information from Excel File
#'
#' This function reads data from an Excel file and optionally filters it based on a tracking name.
#' It uses openxlsx2 to read the Excel file and maintains all attributes of the data.
#'
#' @param fichier_info Path to the Excel file containing the information to load
#' @param nom_suivi Optional tracking name to filter the data. If provided, only rows
#'                 where the 'suivi' column matches this value will be returned
#'
#' @return A data frame containing the loaded information. If nom_suivi is provided,
#'         only the filtered rows are returned; otherwise, all rows are returned.
#'
#' @examples
#' # Load all information from file
#' infos <- charger_informations("data/metadata.xlsx")
#'
#' # Load information for specific tracking
#' infos_filtrees <- charger_informations("data/metadata.xlsx", "suivi_1")
#'
#' @export
#'
#' @importFrom dplyr filter
#' @importFrom openxlsx2 read_xlsx
#' @importFrom dplyr %>%
charger_informations <- function(fichier_info, nom_suivi = NULL) {
  infos <- openxlsx2::read_xlsx(file = fichier_info, keep_attributes = TRUE)

  if (!is.null(nom_suivi)) {
    infos %>%
      dplyr::filter(suivi == nom_suivi)
  } else {
    infos
  }
}

#' Format Text as Hyperlinks for Excel
#'
#' This function formats text containing link information into Excel hyperlinks.
#' It processes text in the format "texte:displayed text;lien:url" and creates
#' a hyperlink object using openxlsx2.
#'
#' @param x A character string that may contain link information in the format
#'          "texte:displayed text;lien:url". If the string doesn't match this
#'          format or is NA, it is returned unchanged.
#'
#' @return An Excel hyperlink object if the input contains valid link information,
#'         otherwise returns the input unchanged.
#'
#' @examples
#' # Create a hyperlink
#' formater_liens("texte:Voir document;lien:https://example.com/doc.pdf")
#'
#' # Return unchanged text
#' formater_liens("Simple text without link")
#'
#' @export
#'
#' @importFrom openxlsx2 create_hyperlink
#' @importFrom stringr str_detect str_split_1 str_remove str_trim
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
