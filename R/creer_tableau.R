#' Create an Interactive Data Table
#'
#' This function creates an interactive data table using the DT package.
#' The table includes export buttons for copying, CSV, and Excel formats.
#'
#' @param df A data frame to be displayed as an interactive table
#' @param ... Additional arguments passed to DT::datatable
#'
#' @return A DT datatable object
#'
#' @export
#'
#' @importFrom DT datatable
#'
#' @examples
#' # Create a simple interactive table
#' creer_tableau(data.frame(x = 1:5, y = letters[1:5]))
creer_tableau <- function(df, ...) {
  df |>
    DT::datatable(
      extensions = 'Buttons',
      options = list(dom = 'lfrtipB',
                     buttons = c('copy', 'csv', 'excel')),
      ...)
}

#' Create an Interactive Table from Spatial Data
#'
#' This function reads a spatial file containing station information,
#' removes the geometry column, and creates an interactive data table.
#'
#' @param stations Path to a spatial file containing station information
#'
#' @return A DT datatable object containing the station information
#'
#' @export
#'
#' @importFrom sf st_read st_drop_geometry
#'
#' @examples
#' # Create a table from a shapefile of monitoring stations
#' # creer_tableau_stations("path/to/stations.shp")
creer_tableau_stations <- function(stations) {
  sf::st_read(stations, quiet = TRUE) |>
    sf::st_drop_geometry() |>
    creer_tableau()
}
