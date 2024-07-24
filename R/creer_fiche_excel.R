#' Title
#'
#' @param nom_suivi
#' @param fichier_info
#' @param chemin_fiche
#'
#' @export
#'
#' @importFrom openxlsx2 wb_load wb_save
creer_fiche_excel <- function(nom_suivi, fichier_info, chemin_fiche, region = NULL) {
  fiche <- openxlsx2::wb_load(
    file = system.file(
      "extdata", "fiche.xlsx",
      package = "FichesSRC"
    ),
    sheet = 1
  )

  infos <- charger_informations(fichier_info, nom_suivi = nom_suivi)

  remplir_cellule(
    classeur = fiche,
    cellule = "A49",
    valeur = paste0("Editée le ", Sys.Date())
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C1",
    valeur = infos$intitule
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L1",
    valeur = infos$intitule
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "G6",
    valeur = infos$logo,
    largeur = 4.5,
    hauteur = 3.8
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C8",
    valeur = infos$description
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C12",
    valeur = infos$objectif
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C16",
    valeur = infos$utilisation
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "B22",
    valeur = creer_carte(
      departements = infos$departements,
      region = region,
      stations = infos$fichier_stations
      ),
    largeur = 6.8,
    hauteur = 8
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "E22",
    valeur = infos$forme_suivi
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "B38",
    valeur = creer_calendrier(infos$mois, web = FALSE),
    largeur = 11,
    hauteur = 3
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "B43",
    valeur = infos$temporalite
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "G13",
    valeur = infos$animation
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "G31",
    valeur = infos$partenaires
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C47",
    valeur = formater_liens(infos$plus_recto1)
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C48",
    valeur = formater_liens(infos$plus_recto2)
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "C49",
    valeur = formater_liens(infos$plus_recto3)
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L6",
    valeur = infos$duree
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M6",
    valeur = infos$nombre_agents
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "O6",
    valeur = creer_graphe_expertise(niveau = infos$expertise),
    largeur = 5.8,
    hauteur = 1.6
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "K11",
    valeur = infos$role_national
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L11",
    valeur = infos$role_regional
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "M11",
    valeur = infos$role_departemental
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "O9",
    valeur = infos$droits_formations
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "K16",
    valeur = infos$protocole
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "O16",
    valeur = infos$materiel
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L29",
    valeur = infos$saisie_validation
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "O29",
    valeur = infos$diffusion
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "K29",
    valeur = infos$autres_releves
  )

  if (!is.na(infos$autres_releves)) {
    remplir_cellule(
      classeur = fiche,
      cellule = "K43",
      valeur = paste0("Autres relevés: ", infos$autres_releves)
    )

    if (!is.na(infos$transversalite)) {
      remplir_cellule(
        classeur = fiche,
        cellule = "K45",
        valeur = paste0("Transversalité: ", infos$transversalite)
      )
    }
  } else {
    if (!is.na(infos$transversalite)) {
      remplir_cellule(
        classeur = fiche,
        cellule = "K43",
        valeur = paste0("Transversalité: ", infos$transversalite)
      )
    }

  }

  remplir_cellule(
    classeur = fiche,
    cellule = "L47",
    valeur = formater_liens(infos$plus_verso1)
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L48",
    valeur = formater_liens(infos$plus_verso2)
  )

  remplir_cellule(
    classeur = fiche,
    cellule = "L49",
    valeur = formater_liens(infos$plus_verso3)
  )

  openxlsx2::wb_save(
    wb = fiche,
    file = chemin_fiche,
    overwrite = TRUE
  )

}
