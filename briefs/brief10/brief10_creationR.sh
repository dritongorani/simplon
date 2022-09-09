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