# Du IaaS au SaaS, par script !
création: 24/05/2022
groupe 3: Alain, Amine, Billal, Loïc, Saïf
***
## Table des matières
>- Objectif
>- Prérequis
>- Groupe de ressource
>- Plan App Service
>- App Service avec PHP
>- Service MariaDb (sécurisé)
>- PHPMyAdmin 
>- Script bash d'installation intéractive
>- Problèmes rencontrés
---
## Objectif
- Création d'une webapp avec database MariaDB sur Azure en SaaS.
- BONUS : Un script BASH permet de rendre l'installation intéractive en demandant à l'utilisateur les paramètres à utiliser dans le script.
- BONUS 2 : Création d'un annuaire des gares avec la web app via injection des données dans la BDD.

## Prérequis
- Une License Microsoft valide
- Avoir un accés Azure Cloudshell pour entrer les commandes
	![1.jpg](../../_resources/1.jpg)
 
---
> Pour la création des differentes ressources, nous nous aidons de azure interactive pour avoir la suggestion des parametres et options disponibles
`az interactive`
## Groupe de ressource

Créer un groupe de ressource **G3_Brief4_SAAS_AS**
Nous choisissons eastus pour être moin limité en terme d'offre azure database pour mariadb server.
`az group create --name G3_Brief4_SAAS_AS --location eastus`

---
##  Plan App Service avec linux

Créer un plan de service **ASP_G3_Brief4_AS**
`az appservice plan create --name ASP_G3_Brief4_AS --resource-group G3_Brief4_SAAS_AS --location eastus --is-linux --per-site-scaling --sku P1V2`

---
## App Service avec PHP

Création webapp **ASG3Brief4AS**
`az webapp create --name ASG3Brief4AS --plan ASP_G3_Brief4_AS --resource-group G3_Brief4_SAAS_AS --runtime "PHP:8.0"`

---
##  Azure Database for MariaDB server

Creation du service database pour Mariadb **mdbg3brief4as**
> nous désactivons ssl et autorisons l'accès à toutes les adresse ip le temps du test

`az mariadb server create --name mdbg3brief4as --resource-group G3_Brief4_SAAS_AS --location eastus --admin-user mdbg3admin1 --admin-password Adminpass1 --sku-name GP_Gen5_2 --version 10.3 --public all --ssl-enforcement Disabled`

>connection test à mariadb :
`mysql --host mdbg3brief4as.mariadb.database.azure.com --user mdbg3admin1@mdbg3brief4as -p`
![mariadbco](../../_resources/7.jpg)


---
### PHPMyAdmin 

> Pour faire le lien avec le service de base de données MariaDB d'Azure , nous installons PhpMyAdmin sur la webapp.

- Connexion ssh à la webapp
![1.jpg](../../_resources/1-1.jpg)


- Etats des lieux :
	- PHP 8.0.13![2.jpg](../../_resources/2.jpg)


	- Debian 10 `cat /etc/os-release` 
	- Nginx 1.14.2 `nginx -v`
- Télechargement d'une version à jour de PhpMyAdmin :
`wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz`

- Décompression du fichier téléchargé:
`tar xvf phpMyAdmin-5.2.0-all-languages.tar.gz`
- Accés à phpmyadmin depuis le site web :
>- il est possible de mettre directement phpmyadmin à la racine du site avec la commande `mv phpMyAdmin-*/* /home/site/wwwroot` , ainsi la page phpmyadmin devient accessible depuis la racine du site via son fichier index.php.
![3.jpg](../../_resources/3.jpg)
>- Nous mettons phpmyadmin dans le dossier /pma à la racine pour ne pas tout mélanger `mkdir /home/site/wwwroot/pma`
> `mv phpMyAdmin-*/* /home/site/wwwroot/pma`
![4.jpg](../../_resources/4.jpg)

- Accés à la base de donnée Mariadb distante:
	- création du fichier config.inc.php à partir de config .sample.inc.php
	`cp config.sample.inc.php config.inc.php`
	- edition du fichier config.inc.php
	`nano config.inc.php`
	- generation d'une sequence aleatoire avec `openssl -rand64 32`
	- ajout de la sequence générée dans la ligne `$cfg['blowfish_secret'] = 'nwEaDzXg7U/4uESelcy988ruk6khdQrKkS3Am3QWhXQ=';`
	- ajout à la suite des parametres servers : 
	`$cfg['CheckConfigurationPermissions'] = false;`
	- sauvegarde du fichier
	- `service reload nginx`
	- nous pouvons nous connecter à la db mariadb distante avec nos identifiant.
![5.jpg](../../_resources/5.jpg)
![6.jpg](../../_resources/6.jpg)




---

## Script bash d'installation intéractive

Nous automatisons la création du groupe de ressource, de l'Azure service plan, de la web app et de Mariadb, avec un script bash, qui pourra être amélioré à l'avenir.
Option ajouté pour la suppression des ressources crées.

Nous allons simplement enchainer les différentes commandes necessaires, avec pour but de supprimer les répétitions de variable en les definissant une fois pour toute dans les parametres de lancement du script.





[lemp.sh](../../_resources/lemp.sh)




```bash
#! /bin/bash
echo "*******************************************************"
echo "*Script de creation de ressources Azure version 0.0001*""
echo "* non securisé !!!                                                       *""
echo "********************************************************"
#recuperation des infos
echo "Entrer localisation"
read localisation
echo "Entrer nom du groupe de ressource"
read nomGroupe
echo "Entrer nom du plan Azure service"
read nomPlan
echo "Entrer nom de la webapp"
read nomWebapp
echo "Entrer nom du service db pour Mariadb"
read nomMariadb
echo "Entrer nom admin mariadb"
read adminMariadb
echo "Entrer pass pour admin mariadb"
read adminMariadbPass

>#creation des ressources

>echo "Creation du groupe de ressource en cour..."
az group create --name $nomGroupe --location $localisation
echo "Groupe de ressource "$nomGroupe" crée"

>echo "Creation du plan azure service en cours..."
az appservice plan create --name $nomPlan --resource-group $nomGroupe --location $localisation --is-linux --per-site-scaling --sku P1V2
echo "plan azure service "$nomPlan" crée"

>echo "Creation de la webapp en cours..."
az webapp create --name $nomWebapp --plan $nomPlan --resource-group $nomGroupe --runtime "PHP:8.0"
echo "Webapp "$nomWebapp" crée"

>echo "Creation du service db pour Mariadb en cours..."
az mariadb server create --name $nomMariadb --resource-group $nomGroupe --location $localisation --admin-user $adminMariadb --admin-password $adminMariadbPass --sku-name GP_Gen5_2 --version 10.3 --public all --ssl-enforcement Disabled
echo "Service db pour Mariadb "$nomMariadb" crée"

>#Suppression des ressources
echo "Souhaitez vous supprimer les ressources crées ? (Y=Yes , N=No)"
read suppression
if [[($suppression == "y")]]; then
echo "Début de la suppression des ressources"
az webapp delete --name $nomWebapp --resource-group $nomGroupe
echo "suppression de la webapp en cours ..."
echo "webapp supprimée ..."
az mariadb server delete --resource-group $nomGroupe --name $nomMariadb
echo "suppression de mariadb en cours ..."
echo "mariadb db supprimée ..."
az appservice plan delete --name $nomPlan --resource-group $nomGroupe
echo "suppression du app service plan en cours ..."
echo "app service plan supprimé ..."
az group delete --name $nomGroupe
echo "suppression du groupe de ressource en cours ..."
echo "groupe de ressource supprimé ..."
echo "Toutes les ressources précedement crées ont été supprimées!"
else
echo "aurevoir "
fi
```

---

## Problèmes rencontrés

- Lors de la configuration de phpmyadmin: dès création de config.inc.php nginx fail, 
	- essai de création du fichier config.inc.php via /setup mène au même problème
	- création d'un fichier vierge mène au même problème
	- quelquechose semble devoir être à activer sur nginx pour pouvoir faire le fichier config.inc.php
	- solution : ajouter la ligne : `$cfg['CheckConfigurationPermissions'] = false;`dans le fichier config.inc.php de phpmyadmin, les parametres de securités du serveurs sont peut être trop bas est ne passe pas les seuil requis par ce check.
- Chown non utilisable, propriétaire nobody et nogroup pour le serveur avec permission maximale, je ne sais pas comment changer en www-data:www-data, chown ne semble pas fonctionner.




