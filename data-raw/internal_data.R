ensure_multipolygons <- function(X) {
  # https://gis.stackexchange.com/questions/389814/r-st-centroid-geos-error-unknown-wkb-type-12
  tmp1 <- tempfile(fileext = ".gpkg")
  tmp2 <- tempfile(fileext = ".gpkg")
  sf::st_write(X, tmp1)
  gdalUtilities::ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- sf::st_read(tmp2)
  sf::st_sf(sf::st_drop_geometry(X), geom = sf::st_geometry(Y))
}

limites_departements <- sf::st_read(
  dsn = "https://data.geopf.fr/annexes/ressources/wfs/administratif.xml",
  layer = "ADMINEXPRESS-COG-CARTO.LATEST:departement"
  ) %>%
  ensure_multipolygons()

usethis::use_data(limites_departements, internal = TRUE, overwrite = TRUE)
