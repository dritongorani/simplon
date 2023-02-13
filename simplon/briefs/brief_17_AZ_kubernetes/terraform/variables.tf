variable "agent_count" {
  default = 3
}


# variable "aks_service_principal_app_id" {
#   default = ""
# }

# variable "aks_service_principal_client_secret" {
#   default = ""
# }

variable "cluster_name" {
  default = "dritonclustertest"
}

variable "dns_prefix" {
  default = "k8stest"
}



variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

# variable "resource_group_name_prefix" {
#   default     = "PERSO_DRITON"
#   description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
# }

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}
