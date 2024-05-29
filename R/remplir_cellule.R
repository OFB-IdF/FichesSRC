#' Title
#'
#' @param classeur
#' @param feuille
#' @param cellule
#' @param valeur
#'
#' @return
#' @export
#'
#'
remplir_cellule <- function(classeur, feuille = 1, cellule, valeur, largeur = NULL, hauteur = NULL, unite = "cm") {
  if (any(!is.na(valeur))) {
    if ("ggplot" %in% class(valeur)) {
      print(valeur)

      classeur$add_plot(
        sheet = feuille,
        dims = cellule,
        width = largeur,
        height = hauteur,
        units = unite,
        dpi = 300
      )
    } else {
      if (stringr::str_detect(string = valeur, pattern = ".jpg$|.png$")) {
        if (stringr::str_detect(string = valeur, pattern = "^http")) {
          tmp <- tempfile(fileext = paste0(".", tools::file_ext(valeur)))
          download.file(valeur, tmp, mode = "wb")

          valeur <- tmp
        }

        dimensions <- magick::image_read(valeur) %>%
          magick::image_scale(geometry = paste0(largeur*300/2.54, "x", hauteur*300/2.54)) %>%
          magick::image_info()

        classeur$add_image(
          sheet = feuille,
          dims = cellule,
          file = valeur,
          width = dimensions$width,
          height = dimensions$height,
          units = "px",
          dpi = 300
        )
      } else {
        if (stringr::str_detect(string = valeur, pattern = "=HYPERLINK")) {
          classeur$add_formula(
            sheet = feuille,
            x = valeur,
            dims = cellule
          )
        } else {
          classeur$add_data(
            sheet = feuille,
            x = valeur,
            dims = cellule
          )
        }

      }
    }

  }
}
