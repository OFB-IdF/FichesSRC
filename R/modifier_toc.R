#' Modify Table of Contents in HTML Content
#'
#' This function modifies the table of contents structure in HTML content by inserting
#' new navigation elements before a target line. It specifically adds structured navigation
#' for description, objectives, utilization, and animation sections.
#'
#' @param html_content A character vector containing HTML content to be modified,
#'   typically the content of a Quarto-generated HTML file
#'
#' @return A modified character vector with updated table of contents structure,
#'   including new navigation elements for the monitoring sheet sections
#' @keywords internal
#'
#' @importFrom stringr str_which fixed
#'
#' @examples
#' \dontrun{
#' # Read HTML content from a file
#' html_content <- readLines("monitoring_sheet.html")
#' 
#' # Modify the table of contents
#' modified_html <- modifier_toc(html_content)
#' 
#' # Write the modified content back to the file
#' writeLines(modified_html, "monitoring_sheet.html")
#' }
modifier_toc <- function(html_content) {
  target_line <- '<li><a href="#le-suivi" id="toc-le-suivi" class="nav-link active" data-scroll-target="#le-suivi">Le suivi</a>'
  new_lines <- c(
    '<li><a href="#description" id="toc-description" class="nav-link active" data-scroll-target="#description">Description</a>',
    '<ul class="collapse">',
    '<li><a href="#objectif" id="toc-objectif" class="nav-link" data-scroll-target="#objectif">Objectif</a></li>',
    '<li><a href="#utilisation" id="toc-utilisation" class="nav-link" data-scroll-target="#utilisation">Utilisation</a></li>',
    '</ul></li>',
    '<li><a href="#animation" id="toc-animation" class="nav-link" data-scroll-target="#animation">Animation</a></li>'
  )

  # Trouver l'index de la ligne cible
  target_index <- stringr::str_which(html_content, stringr::fixed(target_line))

  # Insérer les nouvelles lignes avant la ligne cible
  if (length(target_index) > 0) {
    html_content <- append(html_content, new_lines, after = target_index - 1)
  }

  html_content
}