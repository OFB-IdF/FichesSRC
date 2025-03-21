#' Load and format information from a Google Sheet
#'
#' This function processes data from a Google Sheet containing monitoring information
#' and formats it into a structured list for use in creating monitoring sheets.
#'
#' @param infos A data frame containing raw information from the Google Sheet
#' @param suivi The name of the monitoring sheet being processed
#' @param region Optional. The region code to be used in the output
#'
#' @return A list containing formatted monitoring information including:
#'   \itemize{
#'     \item intitule: The title of the monitoring
#'     \item description: Detailed description of the monitoring
#'     \item objectif: Objectives of the monitoring
#'     \item temporalite: Temporal aspects of the monitoring
#'     \item role_national, role_regional, role_departemental: Roles at different levels
#'     \item And various other monitoring metadata
#'   }
#'
#' @export
#'
#' @importFrom dplyr filter %>%
charger_informations <- function(infos, suivi, region) {
    colnames(infos) <- LETTERS[seq(ncol(infos))]
    
    list(
        intitule = infos$C[1],
        suivi = suivi,
        logo = infos$I[6],
        description = infos$C[8],
        objectif = infos$C[12],
        utilisation = infos$C[16],
        animation = infos$I[13],
        partenaires = infos$I[31],
        fichiers_stations = "",
        departements = infos$C[22],
        region = region,
        forme_suivi = infos$F[24],
        temporalite = infos$B[45],
        mois = formater_mois(infos[37:44, c("B", "C", "D", "E", "F", "G", "H")]),
        role_national = infos$L[11],
        role_regional = infos$M[11],
        role_departemental = infos$N[11],
        duree = infos$M[6],
        nombre_agents = infos$N[6],
        expertise = infos[7, c("P", "Q", "R", "S", "T")][!is.na(infos[6, c("P", "Q", "R", "S", "T")])],
        droits_formation = infos$P[9],
        protocole = infos$L[16],
        materiel = infos$P[16],
        autres_releves = infos$M[43],
        saisie_validation = infos$M[29],
        diffusion = paste(
            na.omit(c(
                infos$P[29],
                infos$P[32],
                infos$P[35],
                infos$P[37]
            )),
            collapse = "\n"
        ),#PROBLEME: ne récupère pas les liens, seulement le texte
        plus_recto1 = c(infos$C[47], infos$G[47]),
        plus_recto2 = c(infos$C[48], infos$G[48]),
        plus_recto3 = c(infos$C[49], infos$G[49]),
        plus_verso1 = c(infos$M[47], infos$P[47]),
        plus_verso2 = c(infos$M[48], infos$P[48]),
        plus_verso3 = c(infos$M[49], infos$P[49])
    )
}
