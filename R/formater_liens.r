#' Format Text as Hyperlinks
#'
#' This function formats text as hyperlinks for either web (HTML) or Excel outputs.
#' It takes a list containing text and link elements and returns a formatted hyperlink.
#'
#' @param infos_lien A list containing two elements: 'text' (the text to be displayed) and 'link' (the URL or file path).
#' @param target Character string specifying the output format. Must be either "web" or "excel".
#'
#' @return For web targets, returns an HTML anchor tag with the link and text.
#'         For Excel targets, returns a hyperlink object created with openxlsx2::create_hyperlink.
#'         If the link element is NA, returns the original text without formatting.
#'
#' @examples
#' # For web output
#' formater_liens(list(text = "Click here", link = "https://example.com"), "web")
#'
#' # For Excel output
#' formater_liens(list(text = "Click here", link = "https://example.com"), "excel")
#'
#' # When link is NA
#' formater_liens(list(text = "Just text", link = NA), "web")
#'
#' @export
#' @importFrom openxlsx2 create_hyperlink
formater_liens <- function(infos_lien, target) {
  if (!target %in% c("web", "excel"))
    stop("La valeur de target doit être 'web' ou 'excel'.")

  if (!is.null(infos_lien)) {
    if (is.na(infos_lien$link))
      return(infos_lien$text)

    if (target == "web") {
      # Vérifier si le lien est un chemin de fichier local (commence par file:)
      if (grepl("^file:", infos_lien$link)) {
        # Pour les liens de fichiers locaux, utiliser l'attribut href standard
        # pour que le script link-handler.js puisse les détecter et ajouter les boutons
        paste0(
          "<a href='", infos_lien$link, "'>", 
          infos_lien$text, 
          "</a>"
        )
      } else {
        # Pour les liens web normaux, comportement standard
        paste0("<a href='", infos_lien$link, "' target='_blank'>", infos_lien$text, "</a>")
      }
    } else {
      if (target == "excel") {
        # Nettoyer l'URL pour éviter les erreurs de formule Excel
        url_clean <- gsub("#", "%23", infos_lien$link)  # Encoder les caractères # qui peuvent causer des problèmes
        url_clean <- gsub("\\s", "%20", url_clean)  # Encoder les espaces
        
        # Créer l'hyperlien avec l'URL nettoyée
        tryCatch({
          openxlsx2::create_hyperlink(text = infos_lien$text, file = url_clean)
        }, error = function(e) {
          warning(paste("Impossible de créer un hyperlien pour", infos_lien$text, ":", e$message))
          # Retourner simplement le texte en cas d'erreur
          infos_lien$text
        })
      }
    }
  }

}
