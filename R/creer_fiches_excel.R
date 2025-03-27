#' Télécharger et filtrer les onglets d'un fichier Excel depuis Google Drive
#'
#' Cette fonction télécharge un fichier Excel depuis Google Drive et ne conserve
#' que les onglets spécifiés dans le paramètre `suivis`. Elle applique également
#' des hyperliens aux cellules appropriées dans chaque feuille du classeur.
#'
#' @param suivis Un vecteur de caractères contenant les noms des onglets à conserver.
#'   Si NULL, tous les onglets sont conservés.
#' @param chemin_fiches Le chemin où sauvegarder le fichier Excel téléchargé.
#'
#' @return Le chemin vers le fichier Excel téléchargé et filtré (invisible).
#'
#' @importFrom googledrive drive_download
#' @importFrom openxlsx2 wb_load wb_get_sheet_names wb_remove_worksheet wb_save
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Télécharger le fichier en ne conservant que certains onglets
#' creer_fiches_excel(suivis = c("suivi1", "suivi2"))
#'
#' # Télécharger tous les onglets
#' creer_fiches_excel()
#' }
creer_fiches_excel <- function(suivis = NULL, chemin_fiches) {
  # Télécharger le fichier depuis Google Drive
  googledrive::drive_download(file = "fiches", path = chemin_fiches, overwrite = TRUE)
  # Charger le fichier Excel
  wb <- openxlsx2::wb_load(chemin_fiches)

  if (!is.null(suivis)) {
  # Obtenir la liste des onglets
  sheet_names <- names(openxlsx2::wb_get_sheet_names(wb))

  # Supprimer les onglets qui ne sont pas dans la liste à conserver
  for (sheet_name in sheet_names) {
    if (!sheet_name %in% suivis) {
      wb <- openxlsx2::wb_remove_worksheet(wb, sheet = sheet_name)
    }
  }
  }

  # Appliquer les hyperliens pour toutes les plages de cellules nécessaires
  for (sheet_name in openxlsx2::wb_get_sheet_names(wb)) {
    appliquer_hyperliens(wb, sheet_name, rows = 47:49, col_texte = "C", col_url = "G", fusion_debut = "C", fusion_fin = "J")
    appliquer_hyperliens(wb, sheet_name, rows = 47:49, col_texte = "M", col_url = "P", fusion_debut = "M", fusion_fin = "T")
    appliquer_hyperliens(wb, sheet_name, rows = 29:42, col_texte = "P", col_url = "S", fusion_debut = "P", fusion_fin = "T")
  }
  # Sauvegarder le fichier Excel
  openxlsx2::wb_save(wb, file = chemin_fiches, overwrite = TRUE)
}

#' Appliquer des hyperliens à des plages de cellules dans un classeur Excel
#'
#' Cette fonction interne permet de créer des hyperliens dans des cellules spécifiées
#' en utilisant le texte d'une colonne et l'URL d'une autre colonne.
#'
#' @param wb Un objet workbook openxlsx2
#' @param sheet_name Le nom de la feuille à modifier
#' @param rows Un vecteur numérique des lignes à parcourir
#' @param col_texte La colonne contenant le texte du lien (ex: "C")
#' @param col_url La colonne contenant l'URL du lien (ex: "G")
#' @param fusion_debut La colonne de début pour la fusion (ex: "C"). Par défaut, identique à col_texte.
#' @param fusion_fin La colonne de fin pour la fusion (ex: "J")
#'
#' @return L'objet workbook modifié
#'
#' @noRd
appliquer_hyperliens <- function(wb, sheet_name, rows, col_texte, col_url, fusion_debut = col_texte, fusion_fin) {
  # Parcourir chaque ligne spécifiée
  for (row_id in rows) {
    # Récupérer le texte et l'URL
    texte_lien <- names(openxlsx2::wb_read(wb, sheet = sheet_name, dims = paste0(col_texte, row_id)))
    url_lien <- names(openxlsx2::wb_read(wb, sheet = sheet_name, dims = paste0(col_url, row_id)))

    # Créer un hyperlien avec le texte et l'URL
    if (!is.na(texte_lien) && !is.na(url_lien)) {
      # Créer l'hyperlien
      hyperlien <- openxlsx2::create_hyperlink(text = texte_lien, file = url_lien)

      # Appliquer l'hyperlien à la cellule
      wb$add_formula(sheet = sheet_name, dims = paste0(col_texte, row_id), x = hyperlien)$
        add_data(wb, sheet = sheet_name, dims = paste0(col_url, row_id), x = "")
    } else {
      if (!is.na(texte_lien)) {
        wb$add_data(sheet = sheet_name, dims = paste0(col_texte, row_id), x = texte_lien)
      }
    }
    wb$
      unmerge_cells(dims = paste0(fusion_debut, row_id, ":", fusion_fin, row_id))$
      merge_cells(sheet = sheet_name, dims = paste0(fusion_debut, row_id, ":", fusion_fin, row_id))
  }

  return(wb)
}
