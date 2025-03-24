#' Format Month Data from a Calendar-like Structure
#'
#' This function processes a data frame containing month headers and activity markers
#' from a calendar-like structure and formats it into a structured data frame for use
#' in calendar visualizations.
#'
#' @param mois_data A data frame containing month headers and activity markers in columns B-H
#'   and rows 1-8, with month names in rows 1 and 5, and activity markers in rows 2-4 and 6-8
#'
#' @return A data frame with columns for month number (mois), month name (mois_lettre),
#'   action name (action), whether the action is performed in that month (action_realisee),
#'   and semester (semestre)
#' @export
#'
#' @examples
#' # Example with a properly formatted mois_data data frame
#' # mois_data <- data.frame(
#' #   B = c("Mois", "Action 1", "Action 2", "Action 3", "", "", "", ""),
#' #   C = c("Jan", "X", "", "", "Jul", "X", "", ""),
#' #   D = c("Feb", "", "X", "", "Aug", "", "X", ""),
#' #   E = c("Mar", "", "", "X", "Sep", "", "", "X"),
#' #   F = c("Apr", "X", "", "", "Oct", "X", "", ""),
#' #   G = c("May", "", "X", "", "Nov", "", "X", ""),
#' #   H = c("Jun", "", "", "X", "Dec", "", "", "X")
#' # )
#' # formater_mois(mois_data)
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

  data.frame(
    mois = seq_along(month_headers),
    mois_lettre = month_headers,
    action_realisee_1 = !is.na(realisation_action_1),
    action_realisee_2 = !is.na(realisation_action_2),
    action_realisee_3 = !is.na(realisation_action_3)
  ) |>
    tidyr::pivot_longer(
      cols = dplyr::starts_with("action_realisee"),
      names_to = "action",
      values_to = "action_realisee"
    ) |>
    dplyr::group_by(action) |>
    dplyr::mutate(nb_realisation = sum(action_realisee)) |>
    dplyr::ungroup() |>
    dplyr::filter(nb_realisation > 0) |>
    dplyr::mutate(
      action = actions[as.integer(stringr::str_remove(action, "action_realisee_"))],
      semestre = ifelse(mois <= 6, "premier", "second")
    ) |>
    dplyr::select(-nb_realisation)
}