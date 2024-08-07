#' Title
#'
#' @param info_mois
#'
#' @export
#'
#' @importFrom dplyr mutate bind_rows tibble full_join
#' @importFrom ggplot2 ggplot geom_tile aes geom_text facet_wrap vars theme_minimal theme element_blank element_text labs scale_fill_manual
#' @importFrom purrr map list_rbind
#' @importFrom stringr str_split str_extract str_remove_all fixed str_replace_na
#' @importFrom tidyr complete nesting
creer_calendrier <- function(info_mois, web = FALSE) {

  infos_mois_format <- formater_mois(info_mois)

  periodes <- infos_mois_format$periodes
  actions <- infos_mois_format$actions

  calendrier <- periodes %>%
    ggplot2::ggplot() +
    ggplot2::geom_tile(
      mapping = ggplot2::aes(x = mois, y = action, fill = action_realisee),
      height = .75
    ) +
    ggplot2::geom_text(
      mapping = ggplot2::aes(x = mois, label = mois_lettre, y = action)
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(hjust = 0, face = "bold"),
      strip.text = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      legend.position = "none"
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
