#' Format month data from a calendar-like structure
#'
#' @param mois_data A data frame containing month headers and activity markers
#'
#' @return A list with actions and periodes components
#' @export
formater_mois <- function(mois_data) {
  # Extract actions from column B if they exist
  actions <- mois_data$B[2:4]
  realisation_action_1 <- c(
    as.character(mois_data[2, c("C", "D", "E", "F", "G", "H")]), 
    as.character(mois_data[6, c("C", "D", "E", "F", "G", "H")])
  )
  realisation_action_2 <- c(
    as.character(mois_data[3, c("C", "D", "E", "F", "G", "H")]), 
    as.character(mois_data[7, c("C", "D", "E", "F", "G", "H")])
  )
  realisation_action_3 <- c(
    as.character(mois_data[4, c("C", "D", "E", "F", "G", "H")]), 
    as.character(mois_data[8, c("C", "D", "E", "F", "G", "H")])
  )
  # Extract month headers from first and fifth rows
  month_headers <- c(
    as.character(mois_data[1, c("C", "D", "E", "F", "G", "H")]), 
    as.character(mois_data[5, c("C", "D", "E", "F", "G", "H")])
  )

  periodes <- data.frame(
    mois = seq_along(month_headers),
    mois_lettre = month_headers,
    action_realisee_1 = !is.na(realisation_action_1),
    action_realisee_2 = !is.na(realisation_action_2),
    action_realisee_3 = !is.na(realisation_action_3)
  ) |>
   tidyr::pivot_longer(
    cols = dplyr::starts_with("action_realisee"),
    names_to = "action",
    values_to = "action_realisee",
  ) |>
  dplyr::group_by(action) |>
  dplyr::mutate(nb_realisation = sum(action_realisee)) |>
  dplyr::ungroup() |>
  dplyr::filter(nb_realisation> 0) |> 
  dplyr::mutate(
    action = actions[as.integer(stringr::str_remove(action, "action_realisee_"))],
    semestre = ifelse(mois <= 6, "premier", "second")
    ) |>
  dplyr::select(-nb_realisation)
  # Return the same structure as the original function
  return(list(actions = actions, periodes = periodes))
}