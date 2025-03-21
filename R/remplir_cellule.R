#' Fill a Cell in an Excel Workbook
#'
#' This function fills a cell in an Excel workbook with various types of content.
#' It can handle text, ggplot2 objects, and image files (local or from URLs).
#' For images and plots, it automatically scales them to the specified dimensions.
#'
#' @param classeur An openxlsx2 workbook object
#' @param feuille Sheet name or index in the workbook (default: 1)
#' @param cellule Cell reference in Excel notation (e.g., "A1")
#' @param valeur The value to insert: text, a ggplot2 object, or a path/URL to an image
#' @param largeur Optional. Width of the image or plot in units specified by 'unite'
#' @param hauteur Optional. Height of the image or plot in units specified by 'unite'
#' @param unite Units for width and height (default: "cm")
#'
#' @return The modified workbook object (invisibly)
#'
#' @export
#'
#' @importFrom magick image_read image_scale image_info
#' @importFrom stringr str_detect
#' @importFrom tools file_ext
#' @importFrom ggplot2 ggsave
#'
#' @examples
#' # Fill a cell with text
#' # wb <- openxlsx2::wb_workbook()
#' # remplir_cellule(wb, cellule = "A1", valeur = "Hello World")
#'
#' # Fill a cell with a ggplot2 object
#' # p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = hp)) + ggplot2::geom_point()
#' # remplir_cellule(wb, cellule = "A5", valeur = p, largeur = 10, hauteur = 8)
remplir_cellule <- function(classeur, feuille = 1, cellule, valeur, largeur = NULL, hauteur = NULL, unite = "cm") {
  if (any(!is.na(valeur))) {
    if ("ggplot" %in% class(valeur)) {
      temp_gg <- tempfile(fileext = ".png")

      ggplot2::ggsave(
        plot = valeur,
        filename = temp_gg,
        width = largeur,
        height = hauteur,
        units = unite
      )

      classeur$add_image(
        sheet = feuille,
        dims = cellule,
        file = temp_gg,
        width = largeur,
        height = hauteur,
        units = unite,
        dpi = 300
      )
    } else {
      if (stringr::str_detect(string = valeur, pattern = ".jpg$|.png$")) {
        telechargement  <- 0

        if (stringr::str_detect(string = valeur, pattern = "^http")) {
          tmp <- tempfile(fileext = paste0(".", tools::file_ext(valeur)))
          telechargement <- try(download.file(valeur, tmp, mode = "wb", quiet = TRUE))

          valeur <- tmp
        }

        if (class(telechargement) != "try-error") {
          dimensions <- magick::image_read(valeur) |>
            magick::image_scale(geometry = paste0(largeur * 300 / 2.54, "x", hauteur * 300 / 2.54)) |>
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
        }


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
