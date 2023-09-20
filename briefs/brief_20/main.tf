terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}



resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.locationofinfra
  name                = var.cluster_name
  resource_group_name = var.resource_group
  dns_prefix          = var.dns_prefix
  tags = {
    Environment = "Development"
  }

  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group PERSO_DRITON --name ${azurerm_kubernetes_cluster.k8s.name}"
  }

  
    provisioner "local-exec" {
    command = "bash ./script.sh"
  }




}