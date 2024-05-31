#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
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
#' @return
#' @export
#'
#' @examples
creer_tableau_stations <- function(stations) {
  sf::st_read(stations, quiet = TRUE) %>%
    sf::st_drop_geometry() %>%
    creer_tableau()
}
