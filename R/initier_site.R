initier_site <- function(dossier_travail) {
  if (!dir.exists(dossier_travail))
    dir.create(dossier_travail)

  copier_www(dossier_travail)

  brew::brew(
    file = system.file("extdata", "productions.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "productions.qmd")
  )
  brew::brew(
    file = system.file("extdata", "ressources.qmd.template", package = "FichesSRC"),
    output = file.path(dossier_travail, "ressources.qmd")
  )
}
