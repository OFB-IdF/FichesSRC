#' Create an Interactive Data Table
#'
#' This function creates an interactive data table using the DT package.
#' The table includes export buttons for copying, CSV, and Excel formats,
#' making it easy for users to extract and use the data in other applications.
#'
#' @param df A data frame to be displayed as an interactive table
#' @param ... Additional arguments passed to DT::datatable, such as options for
#'   customizing the appearance and behavior of the table (e.g., column definitions,
#'   formatting options, pagination settings)
#'
#' @return A DT datatable object that can be displayed in R Markdown documents,
#'   Shiny applications, or Quarto documents
#'
#' @export
#'
#' @importFrom DT datatable
#'
#' @examples
#' # Create a simple interactive table
#' creer_tableau(data.frame(x = 1:5, y = letters[1:5]))
#'
#' # Create a table with custom column names
#' df <- data.frame(id = 1:5, name = c("Alice", "Bob", "Charlie", "David", "Eve"))
#' creer_tableau(df, colnames = c("ID", "Name"))
#'
#' # Create a table with custom options
#' creer_tableau(df, options = list(pageLength = 10, autoWidth = TRUE))
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
#' It supports various spatial file formats (shapefiles, GeoJSON, etc.)
#' that can be read by the sf package.
#'
#' @param stations Path to a spatial file containing station information.
#'   This can be a shapefile, GeoJSON, or any other spatial format supported by sf.
#'   If the file doesn't exist or is not a valid spatial file, an error will be thrown.
#'
#' @return A DT datatable object containing the station information with the
#'   geometry column removed, ready for display in R Markdown documents,
#'   Shiny applications, or Quarto documents
#'
#' @export
#'
#' @importFrom sf st_read st_drop_geometry
#'
#' @examples
#' # Create a table from a shapefile of monitoring stations
#' # creer_tableau_stations("path/to/stations.shp")
#'
#' # Create a table from a GeoJSON file
#' # creer_tableau_stations("path/to/stations.geojson")
creer_tableau_stations <- function(stations) {
  sf::st_read(stations, quiet = TRUE) |>
    sf::st_drop_geometry() |>
    creer_tableau()
}
