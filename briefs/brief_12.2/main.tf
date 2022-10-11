

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}

###########################################################################
#variables
###########################################################################

variable "location" {
    type = string
    default = "francecentral"   
    description = "location of resources"
}

variable "rgname" {
    type = string
    default = "groupe_6"
    description = "resource group name"
}

variable "webappname" {
    type = string
    default = "tonyapp"
  
}

variable "servicplname" {
    type = string
    default = "tonyplan"
  
}

###########################################################################
#Azure Resources
###########################################################################

resource "azurerm_resource_group" "rg" {

    location = var.location
    name = var.rgname
}

resource "azurerm_service_plan" "webplan" {
  name                = var.servicplname
  resource_group_name = var.rgname
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  depends_on = [
    azurerm_resource_group.rg
  ]
}


resource "azurerm_linux_web_app" "webapp" {
  name                = var.webappname
  resource_group_name = var.rgname
  location            = var.location
  service_plan_id     = azurerm_service_plan.webplan.id

  site_config {}
    depends_on = [
    azurerm_resource_group.rg,
    azurerm_service_plan.webplan
  ]
}

###########################################################################
