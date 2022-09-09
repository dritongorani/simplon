# Change these four parameters as needed
ACI_PERS_RESOURCE_GROUP=Groupe5_Brief10_YDA
ACI_PERS_STORAGE_ACCOUNT_NAME=g5b10ydaan
ACI_PERS_LOCATION=westeurope
ACI_PERS_SHARE_NAME=g5b10ydafshare

# Create the storage account with the parameters
az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS

# Create the file share
az storage share create \
  --name $ACI_PERS_SHARE_NAME \
  --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME


STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
echo $STORAGE_KEY

  az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name b5g10ydanginxtest \
    --image nginx:latest \
    --dns-name-label g5b10ydadns \
    --ports 80 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /usr/share/nginx/html/