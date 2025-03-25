#' Create a Calendar Visualization for Monitoring Activities
#'
#' This function creates a calendar-like visualization showing when monitoring activities
#' take place throughout the year. It processes month data and creates a ggplot2 visualization
#' with months on the x-axis and activities on the y-axis. The visualization highlights
#' which months each activity is performed in, making it easy to see the temporal
#' distribution of monitoring activities.
#'
#' @param info_mois A data frame containing month headers and activity markers in a specific format.
#'   This data frame should have the following columns:
#'   \itemize{
#'     \item mois: Numeric month number (1-12)
#'     \item mois_lettre: Character month name or abbreviation
#'     \item action: Character name of the monitoring activity
#'     \item action_realisee: Logical indicating if the action is performed in that month
#'     \item semestre: Character indicating which semester ("premier" or "second")
#'   }
#'   This format is typically produced by the \code{formater_mois} function.
#' @param web Logical. If TRUE, creates a single calendar visualization suitable for web display;
#'   if FALSE, splits the calendar into two semesters using facet_wrap, which is better for
#'   print documents
#'
#' @return A ggplot2 object representing the calendar visualization, ready to be displayed
#'   in R Markdown documents, Shiny applications, or Quarto documents
#'
#' @export
#'
#' @importFrom dplyr mutate bind_rows tibble full_join
#' @importFrom ggplot2 ggplot geom_tile aes geom_text facet_wrap vars theme_minimal theme element_blank element_text labs scale_fill_manual
#' @importFrom purrr map list_rbind
#' @importFrom stringr str_split str_extract str_remove_all fixed str_replace_na
#' @importFrom tidyr complete nesting
#'
#' @examples
#' # Create a calendar visualization for web display
#' # info_mois <- data.frame(
#' #   mois = 1:12,
#' #   mois_lettre = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
#' #                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
#' #   action = rep(c("Field sampling", "Lab analysis", "Reporting"), each = 4),
#' #   action_realisee = c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
#' #                       FALSE, TRUE, TRUE, FALSE),
#' #   semestre = rep(c(rep("premier", 6), rep("second", 6)), 2)
#' # )
#' # creer_calendrier(info_mois, web = TRUE)
creer_calendrier <- function(info_mois, web = FALSE) {

  calendrier <- info_mois|>
    dplyr::mutate(
      action = stringr::str_replace_na(action, "")
    ) |>
    ggplot2::ggplot() +
    ggplot2::geom_tile(
      mapping = ggplot2::aes(x = mois, y = action, fill = action_realisee),
      height = .75
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x.bottom = ggplot2::element_blank(),
      axis.text.x.top = ggplot2::element_text(),
      axis.text.y = ggplot2::element_text(hjust = 0, face = "bold"),
      strip.text = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      legend.position = "none"
    ) +
    ggplot2::scale_x_continuous(
      breaks = info_mois$mois,
      labels = info_mois$mois_lettre,
      sec.axis = ggplot2::dup_axis()
    ) +
    ggplot2::labs(x = "", y = "") +
    ggplot2::scale_fill_manual(values = c(`TRUE` = "darkgrey", `FALSE` = "white"))

  if (!web) {
    calendrier +
      ggplot2::facet_wrap(ggplot2::vars(semestre), nrow = 2, scales = "free_x")
  } else {
    calendrier
  }


}
