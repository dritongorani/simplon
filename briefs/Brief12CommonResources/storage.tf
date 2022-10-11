# resource "azurerm_storage_account" "Brief12StorageAccount" {
#   name                     = var.storage_account_name
#   resource_group_name      = var.resource_group_name
#   location                 = var.resource_group_location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags {
#     environment = "staging"
#   }
# }

# resource "azure_storage_container" "stor-cont" {
#   name                  = var.storage_container_name
#   container_access_type = "blob"
#   storage_service_name  = var.storage_account_name
#   #todo properties = ""
# }