#!/bin/bash

#Recovery information

echo "Enter your location?"
read location


echo "Enter your ressource group name?"
read MyResourceGroup

echo "Enter your web plan name"
read webplanname

echo "Enter your web service name"
read webappname



#Mariadb server
echo "Enter your mariadb name?"
read nameMariadb

echo "Enter your mariadb username?"
read myadmin

echo "Enter your mariadb password?"
read mariadbpass
                
# Creation of a ressource groupe
echo "Creation of ressource group"
az group create --location $location -g $MyResourceGroup --tags {tags}

#Creation of web app plan
echo "Creation of web app plan"
az appservice plan create --name $webplanname -g $MyResourceGroup --location $location --is-linux 

#Creation of a web app

echo "Creation of web app service"
az webapp create --name $webappname --plan $webplanname -g $MyResourceGroup   --runtime "PHP:8.0"



#Creation of mariadb server

echo "Creation of mariadb server in web app"
az mariadb server create --location $location -g $MyResourceGroup --name $nameMariadb --admin-user $myadmin --admin-password $mariadbpass --sku-name GP_Gen5_2



#Delete section 

echo "Do you like to delete your ressource group from azure and all contents inside? Type: Y or N"
read deleteazgroup
if [[($deleteazgroup == "y")]]; then

az webapp delete --name $webappname -g $MyResourceGroup
az mariadb server delete -g $MyResourceGroup --name $nameMariadb
az appservice plan delete --name $webplanname -g $MyResourceGroup
az group delete --name $MyResourceGroup

else



fi