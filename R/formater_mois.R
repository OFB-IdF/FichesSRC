#' Format Month Information for Calendar Display
#'
#' This function processes month-based information and formats it for calendar display.
#' It takes a string containing month information in a specific format and converts it
#' into a structured format suitable for calendar visualization.
#'
#' @param info_mois A character string containing month information in the format
#'                  "action:months" where months are comma-separated numbers (1-12).
#'                  Multiple entries can be separated by newlines.
#'
#' @return A data frame containing formatted month information with columns for
#'         months and corresponding actions. The data is structured for easy
#'         integration with calendar visualization functions.
#'
#' @examples
#' # Format simple month information
#' formater_mois("Action 1:1,2,3\nAction 2:6,7,8")
#'
#' # Format month information with empty action
#' formater_mois(":1,2,3")
#'
#' @export
formater_mois <- function(info_mois) {
  if (!is.na(info_mois)) {
    if (!stringr::str_detect(string = info_mois, pattern = ":"))
      info_mois <- paste0(" :", info_mois)

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

    list(actions = actions, periodes = periodes)
  }

}
