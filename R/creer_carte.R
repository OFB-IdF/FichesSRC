#' Create a Map of Selected Departments
#'
#' This function creates a map highlighting selected departments within a region.
#' It can be used to generate either a static ggplot2 map or an interactive leaflet map.
#' Optionally, it can also display monitoring stations on the map.
#'
#' @param departements Character string containing comma-separated department codes to highlight
#' @param region Optional. The region code to filter departments by region
#' @param stations Optional. Path to a spatial file containing monitoring stations to display on the map
#' @param web Logical. If TRUE, creates an interactive leaflet map; if FALSE, creates a static ggplot2 map
#'
#' @return A map object (either a ggplot2 or leaflet map depending on the web parameter)
#'
#' @export
#'
#' @importFrom dplyr filter mutate
#' @importFrom ggplot2 ggplot geom_sf aes scale_fill_manual theme_void theme
#' @importFrom leaflet leaflet addTiles addPolygons addCircleMarkers
#' @importFrom sf st_read st_as_sf st_geometry_type
#' @importFrom stringr str_split_1 str_trim
#'
#' @examples
#' # Create a static map for departments 75, 77, 78
#' creer_carte(departements = "75, 77, 78", region = "11")
#'
#' # Create an interactive web map
#' creer_carte(departements = "75, 77, 78", region = "11", web = TRUE)
creer_carte <- function(departements, region = NULL, stations = NULL, web = FALSE) {
  if (all(!is.null(stations), !is.na(stations), length(stations) > 0)) {
    stations_sf <- sf::st_read(stations, quiet = TRUE)
  }

  departements <- departements |>
    stringr::str_split_1(pattern = ",") |>
    stringr::str_trim()

  donnees_carte <- limites_departements |>
    sf::st_as_sf()

  # Appliquer le filtre de région si nécessaire
  if (!is.null(region)) {
    donnees_carte <- donnees_carte |>
      dplyr::filter(insee_reg %in% region)
  }

  donnees_carte <- donnees_carte |>
    dplyr::mutate(selected = insee_dep %in% departements)

  if (web) {
    carte <- donnees_carte |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addPolygons(
        weight = 2,
        color = "black",
        opacity = 1,
        fill = ~selected,
        fillColor = "grey25",
        fillOpacity = .25
      )

    if (all(!is.null(stations), !is.na(stations), length(stations) > 0)) {
      if (unique(sf::st_geometry_type(stations_sf)) == "POINT")
        carte <- carte |>
          leaflet::addCircleMarkers(
            data = stations_sf,
            fillColor = "black",
            fillOpacity = 1,
            stroke = FALSE,
            radius = 5,
            label = ~libelle_station
          )
    }
  } else {
    carte <- donnees_carte |>
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        mapping = ggplot2::aes(fill = selected),
        colour = "grey25"
      ) +
      ggplot2::scale_fill_manual(values = c(`TRUE` = "grey", `FALSE` = "white")) +
      ggplot2::theme_void() +
      ggplot2::theme(legend.position = "none")

    if (all(!is.null(stations), !is.na(stations), length(stations) > 0)) {
      carte <- carte +
        ggplot2::geom_sf(data = stations_sf)
    }
  }

  carte

}
