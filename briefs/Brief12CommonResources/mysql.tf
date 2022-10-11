terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.20"
    }
  }
}

provider "azurerm" {
  features {}
}



#######################################################################

#Variables for terraform

locals {
  resource_group = "perso-jeremy"
  location       = "northeurope"
  mysql_name     = "mysqljytest"
}

#################################################################




# Creation d'un groupe de ressource

resource "azurerm_resource_group" "p20cloud" {
  name     = local.resource_group
  location = local.location

  timeouts {
    create = "1m"
  }
}




# Creation mysql server

resource "azurerm_mysql_server" "p20cloud" {
  name                = local.mysql_name
  location            = local.location
  resource_group_name = local.resource_group

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "bud"
  administrator_login_password = "Promo20cloud"
  version                      = "5.7"
  ssl_enforcement_enabled      = true

  depends_on = [azurerm_resource_group.p20cloud]

  timeouts {
    create = "4m"
  }
}





#Creation d'une base de donnée mysql

resource "azurerm_mysql_database" "p20cloud" {
  name                = "databasejytest"
  resource_group_name = local.resource_group
  server_name         = local.mysql_name
  charset             = "utf8"
  collation           = "utf8_unicode_520_ci"


  depends_on = [azurerm_mysql_server.p20cloud]
}




#create firewall rull

data "http" "myip" {
  url = "http://ifconfig.me/ip"
}

resource "azurerm_mysql_firewall_rule" "p20cloud" {
  name                = "office_rule"
  resource_group_name = local.resource_group
  server_name         = local.mysql_name
  start_ip_address    = data.http.myip.body
  end_ip_address      = data.http.myip.body
}

resource "azurerm_mysql_firewall_rule" "p20cloud2" {
  name                = "allow_access"
  resource_group_name = local.resource_group
  server_name         = local.mysql_name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}




#Create login

provider "mysql" {
  endpoint = "${local.mysql_name}.mysql.database.azure.com:3306"
  username = "${azurerm_mysql_server.p20cloud.administrator_login}@${local.mysql_name}"
  password = azurerm_mysql_server.p20cloud.administrator_login_password
  tls      = true
}

resource "mysql_user" "p20cloud" {
  user               = "jeremy"
  host               = "%"
  plaintext_password = "passwordcloud"
}

resource "mysql_grant" "p20cloud" {
  user       = mysql_user.p20cloud.user
  host       = mysql_user.p20cloud.host
  database   = azurerm_mysql_database.p20cloud.name
  privileges = ["SELECT", "UPDATE", "DELETE", "EXECUTE", "INSERT"]
}


