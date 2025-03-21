#' Format Text as Hyperlinks
#' 
#' This function formats text as hyperlinks for either web (HTML) or Excel outputs.
#' It takes a text cell and a link cell and returns a formatted hyperlink.
#' 
#' @param cellule_texte Character string containing the text to be displayed as the hyperlink.
#' @param cellule_lien Character string containing the URL or file path for the hyperlink.
#' @param target Character string specifying the output format. Must be either "web" or "excel".
#' 
#' @return For web targets, returns an HTML anchor tag with the link and text.
#'         For Excel targets, returns a hyperlink object created with openxlsx2::create_hyperlink.
#'         If cellule_lien is NA, returns the original text without formatting.
#' 
#' @examples
#' # For web output
#' formater_liens("Click here", "https://example.com", "web")
#' 
#' # For Excel output
#' formater_liens("Click here", "https://example.com", "excel")
#' 
#' # When link is NA
#' formater_liens("Just text", NA, "web")
#' 
#' @export
#' @importFrom openxlsx2 create_hyperlink
formater_liens <- function(cellule_texte, cellule_lien, target) {
  if (!target %in% c("web", "excel"))
    stop("La valeur de target doit être 'web' ou 'excel'.")

  if (is.na(cellule_lien))
    return(cellule_texte)

  if (target == "web") {
    paste0("<a href='", cellule_lien, "' target='_blank'>", cellule_texte, "</a>")
  } else {
    if (target == "excel")
      openxlsx2::create_hyperlink(text = cellule_texte, file = cellule_lien)
  }
}
