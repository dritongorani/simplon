#######################################################################
#Use these questions if necessary in order to collect data from users.
#######################################################################
echo "Enter your ressource group name?"
read ressourcegroupname
#echo "Enter your VM username?"
#read Vmusername
#echo "Enter your VM password?"
#read Vmpassword
#echo "Enter your Mariadb name?"
#read  MdbName
#echo "Enter your Mariadb username?"
#read Mariadbuser
#echo "Enter your Mariadb password?"
#read Mariadbpass

##################################################
#Put your own informations below
#################################################

##Variables=Personal information###########
appPlanname=planndriton
mywebappname=tonyyywebapp
location="francecentral"
MariaDBname=dritoservermariadb
MDservername=dritonnnservermdb
Mariadbuser=tonytonyuser
Mariadbpass=Driton123456.
# ressourcegroupname=driton_perso
storagename=dritonstorage
appinsightsname=dritonappinsights
################################################################################################################################

#Appservice plan commands:

                                    az appservice plan create \
                                    --resource-group $ressourcegroupname \
                                    --name $appPlanname \
                                    --is-linux \
                                    --location $location \
                                    --number-of-workers 4 \
                                    --sku S1 
 

# # WebAPP create commands:  
az webapp create -g $ressourcegroupname -p $appPlanname -n $mywebappname --runtime "PHP:7.4"

#MariaDB commands:
az mariadb server create -l westeurope -g $ressourcegroupname -n $MariaDBname -u $Mariadbuser -p $Mariadbpass --sku-name GP_Gen5_2 --storage-size "5120" --geo-redundant-backup "Enabled"

#Storage account
az storage account create -n $storagename -g $ressourcegroupname -l $location --sku Standard_LRS

#application insights monitoring:
az monitor app-insights component create --app $appinsightsname --location $location --resource-group $ressourcegroupname
                                         


