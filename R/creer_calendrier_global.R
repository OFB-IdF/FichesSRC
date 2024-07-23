#' Title
#'
#' @param fichier_info
#'
#' @return
#' @export
#'
#' @examples
creer_calendrier_global <- function(fichier_info) {
  calendriers <- openxlsx2::read_xlsx(fichier_info) %>%
    dplyr::select(suivi = intitule, mois) %>%
    dplyr::filter(!is.na(suivi))

  periodes <- calendriers %>%
    dplyr::group_by(suivi) %>%
    dplyr::group_split() %>%
    purrr::map(function(calendrier) {
      if (!is.na(calendrier$mois)) {
        calendrier$mois %>%
          formater_mois() %>%
          '$'("periodes") %>%
          dplyr::mutate(suivi = calendrier$suivi)
      }
    }) %>%
    purrr::list_rbind()


  periodes %>%
    dplyr::filter(mois_lettre == "") %>%
    dplyr::mutate(mois = as.numeric(as.character(mois))) %>%
    ggplot2::ggplot() +
    ggplot2::geom_tile(
      mapping = ggplot2::aes(x = mois, y = action, alpha = action_realisee),
      height = .75, fill = "#003A76"
    ) +
    ggplot2::geom_text(
      mapping = ggplot2::aes(x = mois, label = mois_lettre, y = action)
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      # axis.text.x = ggplot2::element_blank(),
      axis.text.y.left = ggplot2::element_blank(),
      axis.text.y.right = ggplot2::element_text(hjust = 0, face = "bold"),
      strip.text = ggplot2::element_text(face = "bold", size = 12, hjust = 0),
      panel.grid = ggplot2::element_blank(),
      legend.position = "none",
      panel.spacing = ggplot2::unit(0.5, "lines"),  # Adjust the spacing between facets
      strip.background = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(t = 1, r = 1, b = 1, l = 1),
      strip.text.y = ggplot2::element_text(angle = 0, hjust = 1)
    ) +
    ggplot2::labs(x = "", y = "") +
    ggplot2::scale_x_continuous(
      breaks = seq(12),
      labels = c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"),
      sec.axis = ggplot2::dup_axis()
      ) +
    ggplot2::scale_y_discrete(position = "right") +
    ggplot2::scale_alpha_manual(values = c(`TRUE` = 1, `FALSE` = 0)) +
    ggplot2::facet_wrap(
      ggplot2::vars(suivi), scales = "free_y", ncol = 1,
      )

}
