#' Title
#'
#' @param info_mois
#'
#' @return
#' @export
#'
#' @examples
creer_calendrier <- function(info_mois) {
  actions <- info_mois %>%
    stringr::str_split(pattern = "\n") %>%
    unlist() %>%
    stringr::str_extract(pattern = "^.*:") %>%
    stringr::str_remove_all(pattern = ":")

  periodes <- info_mois %>%
    stringr::str_split(pattern = "\n") %>%
    unlist() %>%
    stringr::str_split(pattern = ":") %>%
    purrr::map(
      function(x) {
        data.frame(
          mois = unlist(stringr::str_split(x[2], pattern = stringr::fixed(","))),
          action = x[1]
        )
      }
    ) %>%
    purrr::list_rbind() %>%
    dplyr::mutate(
      mois = as.character(as.numeric(mois))
      ) %>%
    (function(df) {
      if (!any(is.na(df$action))) {
        df %>%
          dplyr::bind_rows(
            dplyr::tibble(
              mois = "1", action = NA
            )
          )
      } else {
        df
      }
    }) %>%
    dplyr::full_join(
      dplyr::tibble(
        mois = as.character(seq(12)),
        mois_lettre = c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")
        ),
      by = "mois"
    ) %>%
    dplyr::mutate(
      action_realisee = TRUE,
      mois = factor(mois, levels = as.character(seq(12)))
      ) %>%
    tidyr::complete(
      tidyr::nesting(mois, mois_lettre), action,
      fill = list(action_realisee = FALSE)
    ) %>%
    dplyr::mutate(
      action_realisee = ifelse(is.na(action), FALSE, action_realisee),
      semestre = ifelse(as.numeric(mois) <= 6, "premier", "second"),
      mois_lettre = ifelse(is.na(action), mois_lettre, "")
    ) %>%
    dplyr::mutate(action = stringr::str_replace_na(action, "") %>%
                    factor(levels = c(actions, "")))

  periodes %>%
    ggplot2::ggplot() +
    ggplot2::geom_tile(
      mapping = ggplot2::aes(x = mois, y = action, fill = action_realisee),
      height = .75
    ) +
    ggplot2::geom_text(
      mapping = ggplot2::aes(x = mois, label = mois_lettre, y = action)
    ) +
    ggplot2::facet_wrap(ggplot2::vars(semestre), nrow = 2, scales = "free_x") +
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

}
