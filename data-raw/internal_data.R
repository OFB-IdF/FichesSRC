limites_departements <- sf::st_read(
  dsn = "https://data.geopf.fr/annexes/ressources/wfs/administratif.xml",
  layer = "ADMINEXPRESS-COG-CARTO.LATEST:departement"
  )

usethis::use_data(limites_departements, internal = TRUE, overwrite = TRUE)
