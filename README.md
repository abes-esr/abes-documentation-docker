# abes-documentation-docker

Cette application met à disposition [la documentation de l'Abes](https://documentation.abes.fr) : manuels, aide en ligne des applications, guide méthodologique, ainsi qu'un moteur de recherche.
Elle propose également un backoffice permettant de mettre à jour la documentation via un accès WebDAV ou SFTP.

Ce dépôt contient toute la configuration docker 🐳 permettant de déployer cette application.

## URLs de documentation.abes.fr

Les URLs correspondantes aux déploiements en dev, test et prod de documentation.abes.fr sont les suivantes :

- prod : https://documentation.abes.fr
- test : https://documentation-test.abes.fr (accès interne Abes)
- dev : https://documentation-dev.abes.fr (accès interne Abes)

## Prérequis

Disposer de :
- ``docker``
- ``docker-compose``

## Installation 

Déployer la configuration docker dans un répertoire :
```bash
# adaptez /opt/pod/ avec l'emplacement où vous souhaitez déployer l'application
cd /opt/pod/
git clone https://github.com/abes-esr/abes-documentation-docker.git
```

Configurer l'application depuis l'exemple du fichier [``.env_dist``](./.env_dist) (ce fichier contient la liste des variables) :
```bash
cd /opt/pod/abes-documentation-docker/
cp .env-dist .env
# personnaliser alors le contenu du .env
```

## Démarrage et arrêt

Pour démarrer l'application :
```bash
sudo docker compose up -d
```
Pour stopper l'application :
```bash
cd /opt/pod/abes-documentation-docker/
sudo docker-compose stop
```

Pour redémarrer l'application :
```bash
cd /opt/pod/abes-documentation-docker/
sudo docker-compose restart
```

Pour supprimer l'application (et ses données !) :
```bash
cd /opt/pod/abes-documentation-docker/
sudo docker compose down -v
# et supprimer les volumes déportés sur le disque local 
rm -fr volumes/
```

## Allocation de ressources et définition des variables pour les conteneurs

Pour ajuster l'allocation de ressources pour les conteneurs (par exemple, mémoire, CPU), vous pouvez modifier la valeur des variables d'environnement suivantes dans votre fichier ``.env`` :

- `DOCUMENTATION_XXXX_MEM_LIMIT`: Mémoire allouée au conteneur XXXX (par exemple: "512m" pour 512 Mo), valeur par défaut "5g".
- `DOCUMENTATION_XXXX_CPU_LIMIT`: CPU alloué au conteneur XXXX (par exemple: "1" pour allouer 1 CPU), valeur par défaut "5".
- `DOCUMENTATION_ENV`: Définit le type d'environnement de déploiement (dev, test, ou prod), cette variable aura un effet sur les URLs absolues du moteur de recherche (qui sont codées en dur dans les fichiers de configuration par facilité)
- `DOCUMENTATION_SFTP_UID` : Définit l'UID utilisé pour l'accès SFTP. Si SFTP et WebDAV sont tous deux activés, il est recommandé de définir cet UID de manière identique à celui utilisé par WebDAV afin d'éviter les conflits de permissions.
- `DOCUMENTATION_SFTP_GID` : Définit le GID utilisé pour l'accès SFTP. Si SFTP et WebDAV sont tous deux activés, il est recommandé de définir ce GID de manière identique à celui utilisé par WebDAV afin d'éviter les conflits de permissions.
- `DOCUMENTATION_WEB_SSH_PRIVATE_KEY` : Définit la clé SSH utilisée pour accéder au GitLab de l'Abes (git.abes.fr) afin d'effectuer un commit/push automatique chaque nuit des documents du site documentation.abes.fr. Ces fichiers sont situés dans le répertoire ``/opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html/`` Ce système de git commit/push automatique est une manière d'historiciser les modifications manuelles qui sont faites via SFTP ou WebDAV.

## Indexation Swish-e

Le moteur de recherche est basé sur le logiciel **swish-e**, intégré à l'aide de l'image Docker ``abesesr/swish-e-docker:1.1.1`` (cf le [dépôt de son image](https://github.com/abes-esr/swish-e-docker))

### Processus d'indexation ###
L'indexation est déclenchée par le script ``/opt/guide/data-swish-e/scripts/indexerGM.sh`` (au sein du conteneur ``documentation-gm-swish-e``). Ce script est exécuté lors du démarrage du conteneur via le Dockerfile. Un délai de quelques secondes est nécessaire lors du lancement du conteneur pour que l'indexation soit finalisée et que le service devienne opérationnel.

### Réindexation automatique ###
Une tâche planifiée (cron) est configurée dans le conteneur ``documentation-gm-swish-e`` pour réindexer les données tous les soir à 20:30.
```bash
30 20 * * * /opt/guide/data-swish-e/scripts/indexerGM.sh >> /var/log/cron.log 2>&1
```
Les journaux de cette tâche sont enregistrés dans ``/var/log/cron.log`` et sont redirigés vers le collecteur de journaux de Docker.

## Supervision

```bash
# pour visualiser les logs de l'appli
cd /opt/pod/abes-documentation-docker/
sudo docker compose logs -f --tail=100
```
Cela va afficher les 100 dernière lignes de logs générées par l'application et toutes les suivantes jusqu'au CTRL+C qui stoppera l'affichage temps réel des logs.

## Sauvegardes

Les éléments suivants sont à sauvegarder:
- ``/opt/pod/abes-documentation-docker/.env`` : contient la configuration spécifique de notre application
- ``/opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html/`` : contient l'ensemble des fichiers HTML et autres documents déposés via SFTP/WebDav

A noter que le répertoire ``/opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html/`` est versionné automatiquement tous les soirs à 21:30 vers le GitLab interne de l'Abes. Un dépôt par instance dev, test et prod :
- dev : https://git.abes.fr/sire/documentation-dev.abes.fr
- test : https://git.abes.fr/sire/documentation-test.abes.fr
- prod : https://git.abes.fr/sire/documentation.abes.fr
