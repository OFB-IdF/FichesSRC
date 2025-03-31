# FichesSRC

Package R pour la création et la gestion d'un tableau de bord de suivi des connaissances.

## Installation et mise en place

### 1. Installation du package

```r
# Installation depuis GitHub avec pak
pak::pkg_install("OFB-IdF/FichesSRC")

# Ou avec remotes
# remotes::install_github("OFB-IdF/FichesSRC")
```

### 2. Copie des fichiers nécessaires

Après l'installation du package, vous devez copier plusieurs fichiers essentiels dans votre répertoire de travail :

```r
# Copie des workflows GitHub (si non existants)
if (!file.exists((".github/workflows/ci.yml"))) {
  file.copy(system.file("extdata", ".github", package = "FichesSRC"), ".", overwrite = TRUE, recursive = TRUE)
}

# Copie du script de déploiement (si non existant)
if (!file.exists("deploiement.R")) {
  file.copy(system.file("extdata", "deploiement.R", package = "FichesSRC"), ".")
}

# Récupération du tableau modèle à compléter
FichesSRC::recuperer_fiches_excel()
```

### 3. Choix du mode d'hébergement des fichiers

Vous avez deux options pour héberger vos données :

#### Option 1 : Fichier Excel local

Modifiez le script `deploiement.R` avec les paramètres suivants :

```r
fichier_infos <- "chemin/vers/votre/fichier.xlsx"  # Chemin vers votre fichier Excel
source_fichier <- "excel"  # Spécifie l'utilisation d'un fichier local
```

#### Option 2 : Google Sheet

Pour utiliser un Google Sheet, vous devez configurer l'authentification Google :

```r
fichier_infos <- "ID_ou_nom_de_votre_google_sheet"  # ID ou nom de votre Google Sheet
source_fichier <- "google_sheet"  # Spécifie l'utilisation d'un Google Sheet
```

Pour la configuration détaillée de l'authentification Google, consultez le [guide d'authentification Google](README.google_auth.md).

### 4. Modification des pages productions et ressources

Après avoir initialisé le site avec `FichesSRC::initier_site("dossier_travail")`, vous devrez modifier manuellement les fichiers suivants :

- `dossier_travail/productions.qmd` : Liste des productions de votre organisation
- `dossier_travail/ressources.qmd` : Ressources utiles et références

Ces fichiers sont générés à partir de templates mais nécessitent une personnalisation selon vos besoins.

### 5. Complétion du tableau des suivis

Complétez le fichier Excel ou Google Sheet récupéré à l'étape 2 avec les informations sur vos suivis. Ce tableau est la source principale des données qui seront affichées dans votre tableau de bord.

Structure recommandée du tableau :
- Onglet principal avec la liste des suivis
- Onglets spécifiques pour chaque suivi avec les détails

### 6. Génération du site en local

Pour générer le site en local, utilisez le script `deploiement.R` :

```r
# Configuration
fichier_infos <- "chemin/vers/votre/fichier.xlsx"  # ou ID Google Sheet
source_fichier <- "excel"  # ou "google_sheet"
dossier_travail <- "tableau_de_bord"
region <- "11"  # Code INSEE de la région

# Génération du site
FichesSRC::initier_site(dossier_travail)
FichesSRC::generer_site(fichier_infos, source_fichier, dossier_travail, region)
```

Le site sera généré dans le dossier `tableau_de_bord/_site`.

### 7. Génération et déploiement avec GitHub Actions

Pour déployer automatiquement votre site sur GitHub Pages :

1. Poussez votre code sur GitHub (incluant le fichier `deploiement.R` et le dossier `.github`)
2. Configurez les secrets GitHub nécessaires :
   - Pour Google Sheet : `GOOGLE_SERVICE_ACCOUNT_JSON` (voir [README.google_auth.md](README.google_auth.md))
3. Activez GitHub Pages dans les paramètres de votre dépôt (source : branche gh-pages)

Le workflow GitHub Actions (`ci.yml`) s'exécutera automatiquement à chaque push sur la branche principale et déploiera le site mis à jour sur GitHub Pages.

## Utilisation avec Docker

Une image Docker est disponible pour faciliter la mise en place et le déploiement du tableau de bord. Elle est utilisable soit en local, soit pour GitHub Actions. Consultez le [guide d'utilisation Docker](README.docker.md) pour plus de détails.

