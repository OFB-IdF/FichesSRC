#' Title
#'
#' @param df
#'
#' @export
#'
#' @importFrom DT datatable
creer_tableau <- function(df, ...) {
  df %>%
    DT::datatable(
      extensions = 'Buttons',
      options = list(dom = 'lfrtipB',
                     buttons = c('copy', 'csv', 'excel')),
      ...)
}

#' Title
#'
#' @param stations
#'
#' @export
#'
#' @importFrom sf st_read st_drop_geometry
creer_tableau_stations <- function(stations) {
  sf::st_read(stations, quiet = TRUE) %>%
    sf::st_drop_geometry() %>%
    creer_tableau()
}
