#' Title
#'
#' @param niveau
#' @param jours
#'
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_tile geom_text geom_point scale_fill_identity theme_void theme unit lims
creer_graphe_expertise <- function(niveau_requis) {
  niveaux <- c("Novice", "Initié", "Formé", "Maitrise", "Expert")

  ggplot2::ggplot(mapping = ggplot2::aes(x = niveau)) +
    ggplot2::geom_tile(
      data = data.frame(
        niveau = factor(niveaux, levels = niveaux),
        couleur = c("#F0E68C", "#7FFF00", "#228B22", "#008B8B", "#0000CD")
      ),
      mapping = ggplot2::aes(y = 1, fill = couleur)
    ) +
    ggplot2::geom_text(
      data = data.frame(niveau = niveau %>%
                          factor(levels = niveaux)),
      mapping = ggplot2::aes(label = niveau), y = .1
    ) +
    # ggplot2::geom_point(
    #   data = data.frame(niveau = factor(niveau, levels = niveaux)),
    #   shape = 21, size = 12, fill = "white", y = 1.75
    # ) +
    # ggplot2::geom_text(
    #   data = data.frame(niveau = factor(niveau, levels = niveaux), nombre_agents = nombre_agents),
    #   mapping = ggplot2::aes(label = nombre_agents),
    #   y = 1.75
    # ) +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.margin = ggplot2::unit(c(0,0,.1,0), "cm")
      ) +
    ggplot2::lims(y = c(-.1, 2.6))
}
