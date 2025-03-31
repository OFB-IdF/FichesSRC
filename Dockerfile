FROM rocker/rstudio:4.3.2

LABEL maintainer="DRIDF"

# Installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    gdal-bin \
    libgdal-dev \
    libudunits2-dev \
    libgeos-dev \
    libproj-dev \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer quarto-cli
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb && \
dpkg -i quarto-1.5.57-linux-amd64.deb && \
rm quarto-1.5.57-linux-amd64.deb

# Installation des packages R nécessaires
RUN install2.r --error \
  --deps TRUE \
  rmarkdown \
  sf \
  leaflet \
  glue \
  googledrive \
  htmltools \
  DT \
  pak \
  brew \
  openxlsx2 \
  tidyverse 

  RUN wget https://cran.r-project.org/src/contrib/quarto_1.4.4.tar.gz && \
    R CMD INSTALL quarto_1.4.4.tar.gz && \
    rm quarto_1.4.4.tar.gz
    
# Script d'entrée qui sera exécuté au démarrage du conteneur
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définition du script d'entrée comme point d'entrée du conteneur
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]