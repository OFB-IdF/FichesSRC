ajouter_goatcounter_tracking <- function(dossier_travail, suivis, goatcounter_id = NULL) {
  if (!is.null(goatcounter_id)) {
    paste0(dossier_travail, "/", suivis, ".qmd") |>
      purrr::walk(
        function(fiche) {
          fiche_txt <- readLines(fiche)
          # Vérifier si le script goatcounter est déjà présent
          if (all(!stringr::str_detect(
            fiche_txt,
            pattern = glue::glue('data-goatcounter="https://{goatcounter_id}.goatcounter.com/count"')
          ))) {
            # Trouver la ligne avec 'include-in-header:' et extraire son indentation
            header_idx <- which(stringr::str_detect(fiche_txt, 'include-in-header:'))
            
            if (length(header_idx) > 0) {
              header_line <- fiche_txt[header_idx]
              # Extraire l'indentation (espaces ou tabulations au début de la ligne)
              indentation <- stringr::str_extract(header_line, "^\\s*")
              if (is.na(indentation)) indentation <- ""
              
              # Vérifier si le header a déjà des éléments (recherche d'un tiret après include-in-header:)
              next_line_idx <- header_idx + 1
              has_items <- FALSE
              
              if (next_line_idx <= length(fiche_txt)) {
                next_line <- fiche_txt[next_line_idx]
                has_items <- stringr::str_detect(next_line, "^\\s*-")
              }
              
              # Calculer l'indentation pour les lignes suivantes
              if (has_items) {
                # Si des éléments existent déjà, utiliser la même indentation que le premier élément
                item_indent <- stringr::str_extract(fiche_txt[next_line_idx], "^\\s*")
                if (is.na(item_indent)) item_indent <- paste0(indentation, "  ")
                
                # Extraire l'indentation du contenu après le tiret
                content_line <- stringr::str_replace(fiche_txt[next_line_idx], "^\\s*-\\s*", "")
                content_indent_extra <- ""
                
                if (stringr::str_detect(content_line, "^\\s*text:\\s*\\|")) {
                  # Si le format est déjà '- text: |', trouver l'indentation du contenu
                  if (next_line_idx + 1 <= length(fiche_txt)) {
                    content_indent <- stringr::str_extract(fiche_txt[next_line_idx + 1], "^\\s*")
                    if (!is.na(content_indent) && nchar(content_indent) > nchar(item_indent)) {
                      content_indent_extra <- content_indent
                    } else {
                      content_indent_extra <- paste0(item_indent, "  ")
                    }
                  } else {
                    content_indent_extra <- paste0(item_indent, "  ")
                  }
                } else {
                  content_indent_extra <- paste0(item_indent, "  ")
                }
                
                # Créer un nouvel élément avec la même indentation
                new_item <- glue::glue("{item_indent}- text: |\n{content_indent_extra}<script data-goatcounter=\"https://{goatcounter_id}.goatcounter.com/count\"\n{content_indent_extra}async src=\"//gc.zgo.at/count.js\"></script>")
                
                # Insérer le nouvel élément après la ligne existante
                fiche_txt <- c(
                  fiche_txt[1:next_line_idx],
                  new_item,
                  fiche_txt[(next_line_idx+1):length(fiche_txt)]
                )
              } else {
                # Si aucun élément n'existe, créer le premier avec une indentation standard
                indent_level1 <- paste0(indentation, "  ")
                indent_level2 <- paste0(indent_level1, "  ")
                
                # Remplacer la ligne include-in-header: par la nouvelle version
                replacement <- glue::glue('{indentation}include-in-header:\n{indent_level1}- text: |\n{indent_level2}<script data-goatcounter="https://{goatcounter_id}.goatcounter.com/count"\n{indent_level2}async src="//gc.zgo.at/count.js"></script>')
                
                fiche_txt[header_idx] <- replacement
              }
              
              # Écrire le fichier modifié
              writeLines(fiche_txt, con = fiche)
            } else {
              # Si 'include-in-header:' n'est pas trouvé, l'ajouter après le titre avec une indentation standard
              title_idx <- which(stringr::str_detect(fiche_txt, '^title:'))
              
              if (length(title_idx) > 0) {
                # Extraire l'indentation du titre
                title_line <- fiche_txt[title_idx]
                indentation <- stringr::str_extract(title_line, "^\\s*")
                if (is.na(indentation)) indentation <- ""
                
                # Créer le header avec la même indentation que le titre
                header_text <- glue::glue('{indentation}include-in-header:\n{indentation}  - text: |\n{indentation}    <script data-goatcounter="https://{goatcounter_id}.goatcounter.com/count"\n{indentation}    async src="//gc.zgo.at/count.js"></script>')
                
                # Insérer après le titre
                fiche_txt <- c(
                  fiche_txt[1:title_idx],
                  header_text,
                  fiche_txt[(title_idx+1):length(fiche_txt)]
                )
                
                # Écrire le fichier modifié
                writeLines(fiche_txt, con = fiche)
              } else {
                # Si aucun titre n'est trouvé, ajouter au début du YAML avec une indentation standard
                yaml_start <- which(stringr::str_detect(fiche_txt, '^---'))[1]
                
                if (!is.na(yaml_start) && yaml_start < length(fiche_txt)) {
                  header_text <- "include-in-header:\n  - text: |\n    <script data-goatcounter=\"https://" + goatcounter_id + ".goatcounter.com/count\"\n    async src=\"//gc.zgo.at/count.js\"></script>"
                  
                  # Insérer après la première ligne de YAML
                  fiche_txt <- c(
                    fiche_txt[1:yaml_start],
                    header_text,
                    fiche_txt[(yaml_start+1):length(fiche_txt)]
                  )
                  
                  # Écrire le fichier modifié
                  writeLines(fiche_txt, con = fiche)
                }
              }
            }
          }
        }
      )
  }
}
