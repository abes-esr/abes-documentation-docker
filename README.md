# abes-documentation-docker


## Introduction
abes-documentation-docker regroupe les services nécessaires pour la diffusion en ligne de la documentation de l'Abes, présentée sous forme de manuels, tels que l’aide en ligne des applications, ainsi que le Guide méthodologique avec son moteur de recherche fonctionnant sous Swish-e. En complément, il intègre également des accès SFTP et WebDAV pour faciliter la mise à jour des documents.

## URLs de documentation.abes.fr

Les URLs correspondantes aux déploiements en dev, test et prod de documentation.abes.fr sont les suivantes :

- dev :
  - https://documentation-dev.abes.fr : homepage de documentation.abes.fr
- test :
  - https://documentation-test.abes.fr : homepage de documentation.abes.fr
- prod :
  - https://documentation.abes.fr : homepage de documentation.abes.fr

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

Pour démarrer les services, il faut lancer la commande suivante :

```bash
sudo docker compose up -d
```
Pour stopper les services :

```bash
cd /opt/pod/abes-documentation-docker/

docker-compose down
```

Pour redémarrer les services :
```bash
docker-compose restart
```

Pour supprimer les données :

```bash
docker compose down -v

#Et supprimer les volumes : 
rm -fr volumes
```

## Allocation de ressources et définition des variables pour les conteneurs

Pour ajuster l'allocation de ressources pour les conteneurs (par exemple, mémoire, CPU), vous pouvez modifier la valeur des variables d'environnement suivantes dans votre fichier ``.env`` :

- `DOCUMENTATION_XXXX_MEM_LIMIT`: Mémoire allouée au conteneur XXXX (par exemple: "512m" pour 512 Mo), valeur par défaut "5g".
- `DOCUMENTATION_XXXX_CPU_LIMIT`: CPU alloué au conteneur XXXX (par exemple: "0.5" pour allouer 50% d'un CPU), valeur par défaut "5".
- `DOCUMENTATION_ENV`: Définit le type d'environnement (dev, test, ou prod).
- `DOCUMENTATION_SFTP_UID` : Définit l'UID utilisé pour l'accès SFTP. Si SFTP et WebDAV sont tous deux activés, il est recommandé de définir cet UID de manière identique à celui utilisé par WebDAV afin d'éviter les conflits de permissions.
- `DOCUMENTATION_SFTP_GID` : Définit le GID utilisé pour l'accès SFTP. Si SFTP et WebDAV sont tous deux activés, il est recommandé de définir ce GID de manière identique à celui utilisé par WebDAV afin d'éviter les conflits de permissions.
- `DOCUMENTATION_WEB_SSH_PRIVATE_KEY` : Définit la clé SSH utilisée pour accéder au GitLab de l'Abes (git.abes.fr) afin d'effectuer un commit automatique chaque nuit des documents du site documentation.abes.fr. Ces fichiers sont situés dans le répertoire /opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html.

## Indexation Swish-e

Le moteur de recherche est basé sur le logiciel **swish-e**, intégré à l'aide de l'image Docker suivante : ``abesesr/swish-e-docker:1.1.1.``
### Processus d'indexation ###
L'indexation est déclenchée par le script ``/opt/guide/data-swish-e/scripts/indexerGM.sh``. Ce script est exécuté lors du démarrage du conteneur via le Dockerfile. Un délai de quelques secondes est nécessaire lors du lancement du conteneur pour que l'indexation soit finalisée et que le service devienne opérationnel.
### Réindexation automatique ###
Une tâche planifiée (cron) est configurée pour réindexer les données tous les soir à 20:30.
```bash
30 20 * * * /opt/guide/data-swish-e/scripts/indexerGM.sh >> /var/log/cron.log 2>&1
```
Les journaux de cette tâche sont enregistrés dans /var/log/cron.log et sont redirigés vers le collecteur de journaux de Docker

## Supervision

```bash
# pour visualiser les logs de l'appli
cd /opt/pod/abes-documentation-docker/
docker-compose logs -f --tail=100
```
Cela va afficher les 100 dernière lignes de logs générées par l'application et toutes les suivantes jusqu'au CTRL+C qui stoppera l'affichage temps réel des logs.

## Sauvegardes

Les éléments suivants sont à sauvegarder:
- ``/opt/pod/abes-documentation-docker/.env`` : contient la configuration spécifique de notre déploiement
- ``/opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html`` : contient l'ensemble des documents de documentation.abes.fr

  A noter que le répertoire /opt/pod/abes-documentation-docker/volumes/documentation-web/var_www_html est versionné automatiquement tous les soirs à 21:30 vers notre GitLab (https://git.abes.fr)
  
  Les dépôts GIT correspondants aux déploiements en dev, test et prod de documentation.abes.fr sont les suivants :

- dev :
  - https://git.abes.fr/sire/documentation-dev.abes.fr
- test :
  - https://git.abes.fr/sire/documentation-test.abes.fr
- prod :
  - https://git.abes.fr/sire/documentation.abes.fr
