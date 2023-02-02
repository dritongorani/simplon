## BRIEF10 : DOCKER + AZURE = ❤️

groupe 5 : Alain, Driton, Yvette

livré le 08/09/2022

liens sripts: https://github.com/Alain-Sardin/brief10/blob/main/brief10_creationR.sh




* * *

### Table des matières

> - Contexte
> - Objectif
> - Estimation initiale du temps de travail
> - Fonctionnement de l'image officielle mediawiki
> - Création des ressources Azure
> - Installation du wiki
> - Génération de l'image modifiée
> - Finalisation de l'installation
> - Script de création ressources Azure
> - Processus d'installation accéléré
> - Problèmes rencontrés

* * *

## Contexte

Le boss en a marre que les mêmes questions reviennent sans cesse. Il s'est promis de mettre en place un outil interne de type "Stack Overflow" et de forcer les prochains questionneurs à l'utiliser.
Il ne sait pas quel outil utiliser, et il attend des propositions. L'utilisation de Docker est parfaite dans ce cas, car c'est rapide et interchangeable.

---

## Objectif
- Nous avons opté pour la mise en place d'un wiki. Cela permetra de documenter les sujets importants pour le Big Boss et d'avoir les réponses aux questions courantes des employés.
- Pour réduire les coûts et travailler la communication, nous utilisons une base de donnée mutualisée MariaDB crée par Salem.
- Dans notre cas cela nous modifie la marche à suivre; nous n'utilisons plus de docker-compose pour generer 2 containers dont une db, mais la création d'un container unique.
- Comme documenté à la suite, l'installation sera faite en 2 étapes: 
    - une premiere étape de génération de la base de données et d'un fichier Local_settings.php à partir de l'image officielle mediawiki:stable à reintegrer à l'image pour cloturer la phase d'installation.
    - une deuxieme étape de géneration d'une image intégrant le fichier de settings et mise en ligne sur dockerhub pour qu'elle soit réutilisable lors de la création du site final.

* * *
## Estimation initiale du temps de travail
le 31/08/2022
temps total: 72h à 3 soit 24h/(8h jour) = 3 jours (voir avec les veilles)

- Determination des objectifs - 3h
- Chercher des infos - 9h
- Creation github perso/groupe - 3h
- Rechercher l'images docker hub adequate - 9h
    - stack overflow
    - db
- Creation ressource en GUI - 6h
    - app service plan
    - webapp
    - slot dev et prod
- Test image dockerhub - 9h
- Configuration image dockerhub - 6h
- Creation du script - 9h
- Debuging script - 9h
- Documentation en markdown - 6h
- Preparation démo orale - 3h



* * *
## Fonctionnement de l'image officielle mediawiki
- L'image mediawiki est faite de façon à rester en procédure d'installation tant que le fichier generé à la fin de cette procédure (Local_settings.php) n'est pas stocker dans le même répertoire que index.php.
Et à ne pas lancer l'installation et la création de la database dédiée si ce même fichier est dans le répertoire d'index.php, et à être en mode "utilisation finale".
- Plan d'action décidé :
    - utiliser l'image officielle mediawiki:stable pour la création des bases de données et du fichier Local_settings.php.
    - garder la db et le fichier Local_settings.php généré pour le premier site
    - premier site que nous allons supprimer d'azure,
    - puis recrer en utilisant les mêmes valeurs grâce à la deuxieme image modifiée pushée sur alaincloud/mediawiki mais intégrant le Local_settings.php.

---
## Création des ressources Azure
    - Groupe de ressource
    - App service plan linux.
    - App service pour la webapp utilisant container docker avec l'image docker-hub mediawiki:stable
    - Ajout de deployment slot DEV au slot déjà existant de Production, utilisant une image alaincloud/mediawiki:dev3 qui servira pour les tests.

---

## Installation du wiki
    - Une fois les ressources crées, depuis l'url du site nous suivons la procédure d'installation de mediawiki.
    - Renseignement des informations :
        - base de données : MariaDB , login, pass et host de salem ainsi que le nom de la database dediée dans le serveur MariaDB (my_wiki).
        - Compte administrateur du wiki
        - Selection des options de fonctionnement du wiki :
            - droit de consultation
            - droit de création d'article limités aux autorisés/ inscrits/ tout le monde.
            - nous laissons le wiki ouvert à tous en lecture et en creation pour la démo, mais pour une utilisation pro il faut plutôt limiter la création d'article aux autorisés inscrits, et la consultation aux inscrits.
    - Voir problème rencontré avec requete (réglé)
    - Génération d'un fichier Local_settings.php à intégrer dans le même répertoire que Index.php dans le conteneur.


---

## Génération de l'image modifiée
Localement avec docker :
- création d'un conteneur basé sur l'image officielle mediawiki:stable
`docker run -tid --name=mediawiki mediawiki:stable`
- transfert du fichier Local_settings.php vers le conteneur au même niveau que le index.php
`docker cp Local_settings.php mediawiki:/var/www/html/`
(nous transferons aussi un logo et modifions lien vers celui ci dans le fichier Local_settings.php).
- Aprés vérification du conteneur avec un `docker exec -ti mediawiki bash` nous en faisons une image que l'on va push.
`docker commit -m "mediawiki avec Localsettings" mediawiki mediawiki:version`.
- Après création d'un compte dockerhub et repos pour mediawiki nous fesons un `docker login`. 
- Pour que l'image soit push sur notre compte et dans le bon repos nous renomons l'image alaincloud/mediawiki:stable. `docker tag <imageid> alaincloud/mediawiki:stable`
- `docker push alaincloud/mediawiki:stable` l'image est sur notre dépot en ligne et ainsi accessible depuis azure.

---
## Finialisation de l'installation
- Nous supprimons l'app service mediawiki.
- Nous le recréons avec l'image alaincloud/mediawiki:stable que nous avons modifié.
- Nous nous rendons sur l'url du site : le wiki est fonctionnel avec son nouveau logo et compte administrateur. 

![resultat](/images/resultat.jpg)

* * *
## Script de création ressources Azure
```bash
## Brief10 : Docker + Azure = love
## Script Done by : Yvette , Driton, Alain

###########################################################
## Script For Web APP Mediawiki - brief 10  Docker Azure ##
###########################################################

#variable preset
group=Groupe5_Brief10_YDA
location=westeurope
appserviceplanname=g5b10ydaasp
webappname=g5b10mediawiki


###########################################################
##Resource group
createRG(){
    echo " creating ressource groupe "
    az group create -n $group -l $location
}

############################################################
## create webapp adqsdq dqdq 
createApp(){
    echo " creating app plan "
    az appservice plan create -g $group  -n $appserviceplanname --is-linux --number-of-workers 4 --sku P1V2
    echo " creating Web app "
    az webapp create --resource-group $group --plan $appserviceplanname --name $webappname --deployment-container-image-name alaincloud/mediawiki:stable
    echo " creating slots"
    # reste à faire
    az webapp deployment slot create  --name $webappname --resource-group $group --slot DEV --deployment-container-image-name alaincloud/mediawiki:dev3 --configuration-source $webappname

    #echo " modif WP-config "
    #az webapp config appsettings set -n alainb8wap -g $group --settings MARIA_DB_HOST="alainb8-mdb.mariadb.database.azure.com" MARIA_DB_USER="$username"  MARIA_DB_PASSWORD="$password"  WEBSITES_ENABLE_APP_SERVICE_STORAGE=TRUE
}
###########################################################
#creation slot
# createSlot(){
#     az webapp deployment slot create  --name $webappname --resource-group $group --slot DEV --deployment-container-image-name alaincloud/mediawiki:dev3 --configuration-source $webappname
# }


############################################################
#tout creer
createAll(){
    createRG
    createApp
}

createAll
#createSlot
echo "installation terminée"
```


---

## Processus d'installation accéléré
*une fois l'image modifiée disponible il est possible de créer le site final plus vite, en utilisant deux slot de deployment dés le debut.*
- création du groupe de ressource
- création de l'app service plan
- création de la webapp avec l'image docker modifiée alaincloud/mediawiki:stable
- création du slot supplémentaire DEV avec l'image officielle mediawiki:stable
- aller sur l'url du site slot DEV et faire l'installation en donnant les futurs infos du site prod, la db et compte admin est généré.
- le site de production est ensuite accessible en version finalisée.


* * *

## Problèmes rencontrés
- difficultés à trouver une image adéquate.
- test de plusieurs images dont askbot avec sqlite avec pour objectif d'utiliser un volume monté en fileshare ou blob dans un azure storage, avant de changer.
- avec l'image mediawiki :
    - Problème de génération de la base de donnée médiawiki , en particulier une requete basée sur l'engine MyISAM alors qu'Azure ne supporte que InnoDB.
        - Solution : création de la requete en remplaçant manuelement le storage engine par InnoDB directement dans la database. Puis actualisation de la page. (merci Ludo)
    - installation en deux étapes avec un fichier Local_settings.php à réintegrer à l'image
car nous n'avons pas réussi à editer le container sur azure, que ce soit en ssh ou avec méthode de création de context et docker azure login.
        - Solution : nous aurions pu utiliser azure container registry pour stocker nos images privée, generer une access key qui aurait été utilisé pour azure docker login, créer un context et faire les opérations que nous avons fait localement mais sur Azure.
Mais de cette façon nous avons au final quand même pu avoir un workflow ci/cd en pushant des images modifiées localement sur le repo alaincloud/mediawiki qui sont automatiquement deployées en activant le ci/cd dans les slots voulus.
