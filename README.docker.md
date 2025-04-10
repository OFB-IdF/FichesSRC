# Utilisation de Docker avec FichesSRC

Ce document explique comment utiliser Docker pour exécuter le package FichesSRC dans un environnement isolé et reproductible.

## Prérequis

- Docker installé sur votre machine
- Git pour cloner le dépôt (optionnel)

## Construction de l'image Docker

```bash
# Cloner le dépôt (si ce n'est pas déjà fait)
git clone <URL_DU_REPO>
cd FichesSRC

# Construire l'image Docker
docker build -t fiches-src .
```

## Publication de l'image sur Docker Hub

Pour partager l'image avec d'autres utilisateurs, vous pouvez la publier sur Docker Hub :

### Préparation de l'image

```bash
# Se connecter à Docker Hub
docker login

# Tagger l'image avec votre nom d'utilisateur Docker Hub et une version
docker tag fiches-src <nom_utilisateur>/fiches-src:latest
docker tag fiches-src <nom_utilisateur>/fiches-src:1.0.0
```

### Publication sur Docker Hub

```bash
# Pousser les images taguées vers Docker Hub
docker push <nom_utilisateur>/fiches-src:latest
docker push <nom_utilisateur>/fiches-src:1.0.0
```

### Bonnes pratiques pour le tagging

- Utilisez toujours un tag spécifique à la version (ex: `1.0.0`) en plus du tag `latest`
- Suivez le versionnage sémantique (MAJOR.MINOR.PATCH)
- Documentez les changements pour chaque nouvelle version
- Considérez l'utilisation de tags supplémentaires pour des variantes spécifiques (ex: `slim`, `dev`)

## Utilisation de l'image Docker

### Utilisation de l'image depuis Docker Hub

Si l'image a été publiée sur Docker Hub, vous pouvez l'utiliser directement sans avoir à la construire localement :

```bash
# Télécharger l'image depuis Docker Hub
docker pull <nom_utilisateur>/fiches-src:latest

# Ou télécharger une version spécifique
docker pull <nom_utilisateur>/fiches-src:1.0.0
```

Pour voir les versions disponibles, vous pouvez consulter la page de l'image sur Docker Hub : https://hub.docker.com/r/<nom_utilisateur>/fiches-src/tags

Lors de l'utilisation de l'image depuis Docker Hub, remplacez simplement `fiches-src` par `<nom_utilisateur>/fiches-src:tag` dans les commandes d'exécution ci-dessous.

### Mode interactif avec RStudio

Pour utiliser RStudio Server avec le package FichesSRC préinstallé :

```bash
# Avec l'image locale
docker run -d -p 8787:8787 -e PASSWORD=motdepasse --name fiches-src-rstudio fiches-src rstudio

# Ou avec l'image depuis Docker Hub
docker run -d -p 8787:8787 -e PASSWORD=motdepasse --name fiches-src-rstudio ofbidf/fiches-src:latest rstudio
```

Accédez ensuite à RStudio via votre navigateur à l'adresse http://localhost:8787 avec :
- Utilisateur : rstudio
- Mot de passe : motdepasse

### Exécution d'un script R spécifique

Pour exécuter un script R spécifique :

```bash
# Avec l'image locale
docker run --rm -v $(pwd):/home/rstudio/data fichessrc /home/rstudio/data/mon_script.R

# Ou avec l'image depuis Docker Hub
docker run --rm -v $(pwd):/home/rstudio/data <nom_utilisateur>/fichessrc:latest /home/rstudio/data/mon_script.R
```

## Utilisation dans GitHub Actions

L'image Docker peut être utilisée dans GitHub Actions pour automatiser les tests et le déploiement. Un exemple de workflow est disponible dans le fichier `.github/workflows/ci.yml`.

## Personnalisation

Vous pouvez personnaliser l'image Docker en modifiant le fichier `Dockerfile` selon vos besoins spécifiques.

## Dépannage

### Problèmes courants

1. **Erreur de permission** : Si vous rencontrez des erreurs de permission lors de l'exécution de Docker, essayez d'exécuter la commande avec `sudo` ou ajoutez votre utilisateur au groupe Docker.

2. **Problèmes de mémoire** : Si le conteneur manque de mémoire, vous pouvez augmenter la mémoire allouée avec l'option `-m` :
   ```bash
   docker run -d -p 8787:8787 -e PASSWORD=motdepasse -m 4g --name fichessrc-rstudio fiches-src rstudio
   ```

3. **Accès aux fichiers locaux** : Pour accéder aux fichiers de votre machine locale depuis le conteneur, utilisez l'option `-v` pour monter un répertoire :
   ```bash
   docker run -d -p 8787:8787 -e PASSWORD=motdepasse -v /chemin/local:/home/rstudio/data --name fiches-src-rstudio fiches-src rstudio
   ```