# ###################################################################################################
# ###################################################################################################
# #######################                                                 ###########################
# #######################              Création des ressources            ###########################
# #######################                                                 ###########################
# ###################################################################################################
# ###################################################################################################

# # On commence par faire un az login


# # Création d'un service Bus


# resource "azurerm_servicebus_namespace" "brief12ServiceBus" {
#   name                = var.servicebus_namespace
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Standard"

#   tags = {
#     source = "terraform"
#   }
# }


# # Creéation des queues 


# resource "azurerm_servicebus_queue" "PROD" {
#     count = 10
#   name         = "Prod_servicebus_queue${count.index}"
#   namespace_id = azurerm_servicebus_namespace.brief12ServiceBus.id

#   enable_partitioning = true
# }


# resource "azurerm_servicebus_queue" "DEV" {
#     count = 10
#   name         = "Dev_servicebus_queue${count.index}"
#   namespace_id = azurerm_servicebus_namespace.brief12ServiceBus.id

#   enable_partitioning = true
# }