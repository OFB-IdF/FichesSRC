# Authentification Google Drive pour GitHub Actions

Ce document explique comment configurer l'authentification à Google Drive pour les workflows GitHub Actions.

## Création d'un compte de service Google

1. Accédez à la [Console Google Cloud](https://console.cloud.google.com/)
2. Créez un nouveau projet ou sélectionnez un projet existant
3. Activez l'API Google Drive pour votre projet
   - Dans le menu de navigation, cliquez sur "APIs & Services" > "Library"
   - Recherchez "Google Drive API" et activez-la
4. Créez un compte de service :
   - Dans le menu de navigation, cliquez sur "IAM & Admin" > "Service Accounts"
   - Cliquez sur "Create Service Account"
   - Donnez un nom et une description au compte de service
   - Attribuez le rôle "Viewer" (ou un rôle plus spécifique selon vos besoins)
   - Cliquez sur "Done"
5. Créez une clé pour le compte de service :
   - Cliquez sur le compte de service que vous venez de créer
   - Allez dans l'onglet "Keys"
   - Cliquez sur "Add Key" > "Create new key"
   - Sélectionnez le format JSON
   - Cliquez sur "Create"
   - Le fichier de clé JSON sera téléchargé sur votre ordinateur

## Partage des fichiers Google Drive avec le compte de service

Pour que le compte de service puisse accéder à vos fichiers Google Drive :

1. Ouvrez le fichier JSON de la clé du compte de service
2. Notez l'adresse email du compte de service (champ `client_email`)
3. Dans Google Drive, partagez les dossiers ou fichiers nécessaires avec cette adresse email

## Configuration du secret GitHub

1. Dans votre dépôt GitHub, allez dans "Settings" > "Secrets and variables" > "Actions"
2. Cliquez sur "New repository secret"
3. Nommez le secret `GOOGLE_SERVICE_ACCOUNT_JSON`
4. Dans la zone de valeur, copiez tout le contenu du fichier JSON de la clé du compte de service
5. Cliquez sur "Add secret"

## Utilisation dans les workflows GitHub Actions

Le secret est maintenant disponible dans vos workflows GitHub Actions. Le workflow a été configuré pour utiliser ce secret lors de l'exécution des actions qui nécessitent une authentification à Google Drive.

## Sécurité

- Ne partagez jamais le fichier JSON de la clé du compte de service
- Limitez les autorisations du compte de service au strict minimum nécessaire
- Considérez la rotation régulière des clés pour une sécurité accrue
- Vérifiez régulièrement les activités du compte de service dans les journaux d'audit Google Cloud