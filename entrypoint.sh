#!/bin/bash
set -e

# Installation du package FichesSRC
R -e "pak::pkg_install('OFB-IdF/FichesSRC')"

# Si le conteneur est exécuté en mode interactif (avec RStudio)
if [ "$1" = "rstudio" ]; then
  exec /init
else
  # Sinon, exécuter le script R spécifié en argument
  exec Rscript "$@"
fi