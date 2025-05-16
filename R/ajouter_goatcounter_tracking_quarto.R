#' Ajouter le script de suivi GoatCounter au fichier _quarto.yml
#'
#' Cette fonction ajoute le script de suivi GoatCounter au fichier _quarto.yml
#' pour centraliser le suivi des statistiques du site.
#'
#' @param dossier_travail Chemin du dossier où se trouve le fichier _quarto.yml
#' @param goatcounter_id Identifiant GoatCounter pour le suivi des statistiques du site
#'
#' @return Aucune valeur de retour, fonction appelée pour ses effets secondaires (modification de fichier)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Ajouter le script GoatCounter au fichier _quarto.yml
#' ajouter_goatcounter_tracking_quarto(getwd(), "mon_identifiant")
#' }
ajouter_goatcounter_tracking_quarto <- function(dossier_travail, goatcounter_id) {
  if (!is.null(goatcounter_id)) {
    quarto_yml_path <- file.path(dossier_travail, "_quarto.yml")
    
    if (file.exists(quarto_yml_path)) {
      quarto_yml <- readLines(quarto_yml_path)
      
      # Vérifier si le script goatcounter est déjà présent
      if (all(!stringr::str_detect(
        quarto_yml,
        pattern = glue::glue('data-goatcounter="https://{goatcounter_id}.goatcounter.com/count"')
      ))) {
        # Trouver la section include-in-header
        header_idx <- which(stringr::str_detect(quarto_yml, '\\s*include-in-header:'))
        
        if (length(header_idx) > 0) {
          # Trouver l'indentation de la section text: |
          text_idx <- which(stringr::str_detect(quarto_yml, '\\s*text:\\s*\\|'))
          
          if (length(text_idx) > 0 && text_idx[1] > header_idx[1]) {
            # Trouver la dernière ligne du bloc text: |
            content_lines <- quarto_yml[(text_idx[1] + 1):length(quarto_yml)]
            end_idx <- text_idx[1]
            
            for (i in seq_along(content_lines)) {
              if (!stringr::str_detect(content_lines[i], "^\\s+") || 
                  stringr::str_detect(content_lines[i], "^\\s*[a-zA-Z]+:") ||
                  i == length(content_lines)) {
                end_idx <- text_idx[1] + i - 1
                break
              }
            }
            
            # Extraire l'indentation
            indentation <- stringr::str_extract(quarto_yml[text_idx[1] + 1], "^\\s+")
            if (is.na(indentation)) indentation <- "        "
            
            # Ajouter le script GoatCounter
            goatcounter_script <- glue::glue("{indentation}<script data-goatcounter=\"https://{goatcounter_id}.goatcounter.com/count\" async src=\"//gc.zgo.at/count.js\"></script>")
            
            # Insérer le script avant la fin du bloc text: |
            quarto_yml <- c(
              quarto_yml[1:end_idx],
              goatcounter_script,
              quarto_yml[(end_idx + 1):length(quarto_yml)]
            )
            
            # Écrire le fichier modifié
            writeLines(quarto_yml, quarto_yml_path)
          } else {
            # Si text: | n'existe pas, l'ajouter
            indentation <- stringr::str_extract(quarto_yml[header_idx], "^\\s*")
            if (is.na(indentation)) indentation <- ""
            
            indent_level1 <- paste0(indentation, "  ")
            indent_level2 <- paste0(indent_level1, "  ")
            
            # Créer le nouveau bloc include-in-header
            new_header <- glue::glue("{indentation}include-in-header:\n{indent_level1}text: |\n{indent_level2}<script data-goatcounter=\"https://{goatcounter_id}.goatcounter.com/count\" async src=\"//gc.zgo.at/count.js\"></script>\n{indent_level2}<script>\n{indent_level2}  // Fonction pour vérifier si GoatCounter est bloqué\n{indent_level2}  function checkGoatCounter() {\n{indent_level2}    if (typeof window.goatcounter === 'undefined') {\n{indent_level2}      // Créer la popup si elle n'existe pas déjà\n{indent_level2}      if (!document.getElementById('goatcounter-popup')) {\n{indent_level2}        const popup = document.createElement('div');\n{indent_level2}        popup.id = 'goatcounter-popup';\n{indent_level2}        popup.style.cssText = 'position: fixed; bottom: 20px; right: 20px; background: white; padding: 15px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000; max-width: 300px; font-size: 14px;';\n{indent_level2}        popup.innerHTML = `\n{indent_level2}          <div style=\"margin-bottom: 10px;\">Le suivi des statistiques est actuellement bloqué. Pour nous aider à améliorer ce site, merci de débloquer GoatCounter.</div>\n{indent_level2}          <button onclick=\"this.parentElement.remove(); localStorage.setItem('goatcounter-dismissed', Date.now())\" style=\"background: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer;\">Compris</button>\n{indent_level2}        `;\n{indent_level2}        document.body.appendChild(popup);\n{indent_level2}      }\n{indent_level2}    }\n{indent_level2}  }\n\n{indent_level2}  // Vérifier si la popup a déjà été fermée récemment (moins de 24h)\n{indent_level2}  const lastDismissed = localStorage.getItem('goatcounter-dismissed');\n{indent_level2}  const showPopup = !lastDismissed || (Date.now() - lastDismissed > 24 * 60 * 60 * 1000);\n\n{indent_level2}  if (showPopup) {\n{indent_level2}    // Vérifier après 2 secondes pour laisser le temps au script de se charger\n{indent_level2}    setTimeout(checkGoatCounter, 2000);\n{indent_level2}  }\n{indent_level2}</script>")
            
            # Remplacer la ligne include-in-header: par la nouvelle version
            quarto_yml[header_idx] <- new_header
            
            # Écrire le fichier modifié
            writeLines(quarto_yml, quarto_yml_path)
          }
        } else {
          # Si include-in-header: n'existe pas, l'ajouter à la fin de la section format:html:
          format_idx <- which(stringr::str_detect(quarto_yml, '\\s*format:'))
          html_idx <- which(stringr::str_detect(quarto_yml, '\\s*html:'))
          
          if (length(format_idx) > 0 && length(html_idx) > 0 && html_idx[1] > format_idx[1]) {
            # Trouver la fin de la section format:html:
            end_format_idx <- html_idx[1]
            for (i in (html_idx[1] + 1):length(quarto_yml)) {
              if (!stringr::str_detect(quarto_yml[i], "^\\s+") || i == length(quarto_yml)) {
                end_format_idx <- i - 1
                break
              }
            }
            
            # Extraire l'indentation de html:
            indentation <- stringr::str_extract(quarto_yml[html_idx[1]], "^\\s*")
            if (is.na(indentation)) indentation <- "  "
            
            indent_level1 <- paste0(indentation, "  ")
            indent_level2 <- paste0(indent_level1, "  ")
            indent_level3 <- paste0(indent_level2, "  ")
            
            # Créer le nouveau bloc include-in-header
            new_header <- glue::glue("{indent_level1}include-in-header:\n{indent_level2}text: |\n{indent_level3}<script data-goatcounter=\"https://{goatcounter_id}.goatcounter.com/count\" async src=\"//gc.zgo.at/count.js\"></script>")
            
            # Insérer le nouveau bloc à la fin de la section format:html:
            quarto_yml <- c(
              quarto_yml[1:end_format_idx],
              new_header,
              quarto_yml[(end_format_idx + 1):length(quarto_yml)]
            )
            
            # Écrire le fichier modifié
            writeLines(quarto_yml, quarto_yml_path)
          }
        }
      }
    }
  }
}