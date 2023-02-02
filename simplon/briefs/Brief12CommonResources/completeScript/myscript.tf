terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.23.0"

    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  location =  "north Europe"
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = local.location
}


resource "azurerm_mariadb_server" "emldb" {
  name                         = var.mariadb_server_name
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  sku_name                     = "B_Gen5_2"
  ssl_enforcement_enabled      = false
  administrator_login          = var.mariadb_admin_name
  administrator_login_password = var.mariadb_admin_password
  version                      = "10.2"
}



resource "azurerm_mariadb_firewall_rule" "fw" {
  name                = "simplonapi"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mariadb_server.emldb.name
  start_ip_address    = "185.24.142.170"
  end_ip_address      = "185.24.142.170"
  depends_on = [
    azurerm_mariadb_server.emldb
  ]
}

resource "null_resource" "provision"{

  provisioner "local-exec" {
    command = "bash sqloop.sh"

    environment = {
      server_name = var.mariadb_server_name
      admin_name = var.mariadb_admin_name
      admin_password = var.mariadb_admin_password
      database_name = var.database_name
      number_of_database = var.number_of_database
     }
  }
  triggers = {
    "always_run" = "${timestamp()}"
  }
  
  depends_on = [
    azurerm_mariadb_server.emldb,
    azurerm_mariadb_firewall_rule.fw
  ]

}