#' Title
#'
#' @param departements
#' @param limites_departements
#' @param region
#'
#' @return
#' @export
#'
#' @examples
creer_carte <- function(departements, region = NULL, stations = NULL, web = FALSE) {
  if (all(!is.null(stations), !is.na(stations))) {
    stations_sf <- sf::st_read(stations, quiet = TRUE)
  }

  departements <- departements %>%
    stringr::str_split_1(pattern = ",") %>%
    stringr::str_trim()

  donnees_carte <- limites_departements %>%
    sf::st_as_sf() %>%
    (function(df) {
      if (is.null(region)) {
        df
      } else {
        df %>%
          dplyr::filter(insee_reg %in% region)
      }
    }) %>%
    dplyr::mutate(selected = insee_dep %in% departements)

  if (web) {
    carte <- donnees_carte %>%
      leaflet::leaflet() %>%
      leaflet::addTiles() %>%
      leaflet::addPolygons(
        weight = 2,
        color = "black",
        opacity = 1,
        fill = ~selected,
        fillColor = "grey25",
        fillOpacity = .25
      )

    if (all(!is.null(stations), !is.na(stations))) {
      if (unique(sf::st_geometry_type(stations_sf)) == "POINT")
        carte <- carte %>%
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
    carte <- donnees_carte %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        mapping = ggplot2::aes(fill = selected),
        colour = "grey25"
      ) +
      ggplot2::scale_fill_manual(values = c(`TRUE` = "grey", `FALSE` = "white")) +
      ggplot2::theme_void() +
      ggplot2::theme(legend.position = "none")

    if (all(!is.null(stations), !is.na(stations))) {
      carte <- carte +
        ggplot2::geom_sf(data = stations_sf)
    }
  }

  carte

}
