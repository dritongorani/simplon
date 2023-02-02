## notes de groupe Mariadb

### sur terraform:
- commande de creation de ressource Mariadb 
- commandes de creation des tables dans Mariadb 
- commandes de creation des users et pass  (soit en sql/bash) voir si possible terraform
- script boucle generation de nom et pass

### securité pass
- azure keyvault pour sauvegarder pass
    - secret
    - https://www.ntweekly.com/2021/02/02/add-a-secret-to-azure-key-vault-with-terraform/
- service principal
    - voir si on peut se connecter avec ca à mariadb
    - creer une branche dans Active directory pour mariadb et tester
    - attention à ne pas casser le systeme poru tout le monde

---
- ressource groupe test : Brief12_Mariadb_test
- branch mariadb sur github
- structure globale du code
- puissance necessaire pour db (certainement au moin la 1ere offre prod)

---
sur github
- Matomi boss

---
### repartition des taches :
- creation des tables en script terraform (bash ou az si pas mieu) :
    - Matomi, Alain
- boucle terraform ou bash pour generation des pass et users : 
    - Driton, Jeremy


---
### notes vrac
provider "azurerm" {
  tenant_id       = "xxxxx"
  subscription_id = "xxxxx"
  client_id       = "xxxxx"
  client_secret   = "xxxxx"
  features {}
}

### creation de wordpressdb et utilisateur si elle n'existe pas
CREATE DATABASE IF NOT EXISTS $database_wp_name_here default character set utf8 collate utf8_unicode_ci;
CREATE USER IF NOT EXISTS '$username_wp'@'$database_wp_name_here' IDENTIFIED BY '$password_wp';
GRANT ALL on $database_wp_name_here.* to '$username_wp'@'$database_wp_name_here' identified by '$password_wp';
flush privileges;
exit;

--- 
### Nommage
CamilleDeSousaMathieu
juste je vous demande que tant qu'on a pas mit en place les variables de bien nommé le group de ressource Brief12CommonResources
et il va sans doute qu'on crée un réseau, alors je propose Brief12CommonResourcesSubnet
- providers.tf  avec version 3.21.1
- mariadb name sans tiret
- dans query sql ne pas mettre de guillemet sauf pour les passwords
