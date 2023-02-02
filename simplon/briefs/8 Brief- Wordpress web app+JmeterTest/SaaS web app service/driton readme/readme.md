
# **Du IaaS au SaaS, par script** ! 

01/06/2022 00:15


## ==Prémier etape== 

### Creation d'une groupe de ressource sur Azure CLI.
#### *`az group create --location --name`*
----

### Creation d'un appservice plan (Output de PHP doit etre la méme avec phpmyadmin)
#### *`az appservice plan create --name --resource-group --output`* 
----

### Creation d'un webapp 
#### *`az webapp create --name --plan --resource-group`*
----

### Creation d'une base de données Mariadb 
#### *`az mariadb server create --admin-password --admin-user --location --public`*
----

## ==Deuxieme etape== 

### Installation de phpmyadmin 
#### `apt update` ####
#### `apt upgrade` ####
#### *`wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz`*
----

### On extract le fichier
#### *`tar xf phpMyAdmin/4.9.7`* 
----

### On deplace tout les fichier de phpmyadmin dans la wwwroot(racine)
#### *`mv phpMyAdmin/4.9.7/*  /home/site/wwwroot`*
----

### On fait une copie deconfig.sample.inc.php vers config.inc.php pour pouvoir apporter des nouvelles modification. 
#### *`cp config.sample.inc.php vers config.inc.php`*
----

### On donne l'autorisation à notre nouveau fichier
#### `chmod -v 0555 /home/site/wwwroot/config.inc.php`
----

### On ouvre le fichier nano config.inc.php et on inject notre URL de base de donnés  mariaDB a la place de "localhost", nous verifions que "SSL" est bien desactivées et "Access to Azure service" est bien activé dans "Connection Security "
#### `tony-mariadb.mariadb.database.azure.com`
----


### On limite l'autorisation à notre nouvau fichier
#### `chmod -v 0770 /home/site/wwwroot/config.inc.php`


