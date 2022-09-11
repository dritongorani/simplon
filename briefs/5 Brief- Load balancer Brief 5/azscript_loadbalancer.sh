#!bin/bash



##################################################

#Datacollect

##################################################
echo "Enter your ressource group name?"
read RGname
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
Vmusername=tonytony
Vmpassword=Driton123456.
MdbName=mymariadbtony
Mariadbuser=dritontony
Mariadbpass=Tonytony123456.
location=eastus
##################################################


#Creation of group of ressource
az group create   --name $RGname  --location $location


#Creation of virtual network
az network vnet create --resource-group $RGname --location $location --name myVNet --address-prefixes 10.1.0.0/16 --subnet-name myBackendSubnet --subnet-prefixes 10.1.0.0/24

#Creation of IP adresse public
az network public-ip create --resource-group $RGname --name myPublicIP --sku Standard --location $location

###################################################################################################################
#Creation of load balancer    LOAD BALANCER
##############################################
az network lb create --resource-group $RGname --name myLoadBalancer --sku Standard --public-ip-address myPublicIP --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool


#Creation of load balancer probe
az network lb probe create --resource-group $RGname --lb-name myLoadBalancer --name myHealthProbe --protocol tcp --port 80


#Create the load balancer rule
az network lb rule create --resource-group $RGname --lb-name myLoadBalancer --name myHTTPRule --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool --probe-name myHealthProbe --disable-outbound-snat true --idle-timeout 15 --enable-tcp-reset true

########################################################################################################################
#Create network security group                  NSG- NETWORK SERCURITY GROUP
###########################################################################################################################
az network nsg create --resource-group $RGname --name myNSG    


#Create network securit group rule
az network nsg rule create --resource-group $RGname --nsg-name myNSG --name myNSGRuleHTTP --protocol '*' --direction inbound --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 --access allow --priority 200


#Create NSG rule SSH
az network nsg rule create --resource-group $RGname --nsg-name myNSG --name NSGule22 --protocol '*' --direction inbound --source-address-prefix '*' --source-
port-range '*' --destination-address-prefix '*' --destination-port-range 22 --access-allow --priority 300
##################################################################################################################################

#Creation of network interface

    array=(myNicVM1 myNicVM2)
    for vmnic in "${array[@]}"
    do
        az network nic create --resource-group $RGname --name $vmnic --vnet-name myVNet --subnet myBackEndSubnet --network-security-group myNSG
  done


#Creataion of first virtual machine and opening porte 22 SSH 
az vm create --resource-group $RGname --name myVM1 --nics myNicVM1 --image Debian:debian-11-daily:11-gen2:0.20220521.1022 --admin-username $Vmusername --admin-password $Vmpassword --zone 1 --no-wait --location $location
az vm open-port --resource-group $RGname --name MyVM1 --port 22-21 --priority 1000

#Creataion of second virtual machine and opening porte 22 SSH
az vm create --resource-group $RGname --name myVM2 --nics myNicVM2 --image Debian:debian-11-daily:11-gen2:0.20220521.1022 --admin-username $Vmusername --admin-password $Vmpassword --zone 2 --no-wait --location $location
az vm open-port -g $RGname -n myVM2 --port 22-21 --priority 1Y000

#Add virtual machines to load balancer backend pool
array=(myNicVM1 myNicVM2)
  for vmnic in "${array[@]}"
  do
    az network nic ip-config address-pool add --address-pool myBackendPool --ip-config-name ipconfig1 --nic-name $vmnic --resource-group $RGname --lb-name myLoadBalancer
  done

  #Create a single IP for the outbound connectivity.
  az network public-ip create --resource-group $RGname --name myNATgatewayIP --sku Standard --zone 1 2 3

  #Create the NAT gateway resource. The public IP created in the previous step is associated with the NAT gateway.
  az network nat gateway create --resource-group $RGname --name myNATgateway --public-ip-addresses myNATgatewayIP --idle-timeout 10

  #Configure the source subnet in virtual network to use a specific NAT gateway resource with az network vnet subnet update.
  az network vnet subnet update --resource-group $RGname --vnet-name myVNet --name myBackendSubnet --nat-gateway myNATgateway


  ##########################
  #Create mariad db server
  ##########################

  #Creation of mariadb server

  az mariadb server create -l $location -g $RGname -n $MdbName -u $Mariadbuser -p $Mariadbpass --sku-name B_Gen5_1 --ssl-enforcement Disabled --backup-retention 10 --geo-redundant-backup disabled --storage-size 51200 --tags "key=value" --version 10.2


  


  echo "Script has been succesufully deployed"

 #########################################

 echo "You need to configure NAT inbound rules  and outband rules in Load Balancer in order to authorize porte 22 SSH and also the same thing on your virtual machines networking, allow mariadb server for azure service."


 this is second commit