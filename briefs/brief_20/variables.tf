variable "agent_count" {
  default = 3
}


# variable "aks_service_principal_app_id" {
#   default = ""
# }

# variable "aks_service_principal_client_secret" {
#   default = ""
# }

variable "resource_group" {
  default = "PERSO_DRITON"
}

variable "locationofinfra" {
  default = "West Europe"
}

variable "cluster_name" {
  default = "dritonclustertest27"
}

variable "dns_prefix" {
  default = "k8stest"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

# variable "resource_group_location" {
#   default     = "eastus"
#   description = "Location of the resource group."
# }

# variable "resource_group_name_prefix" {
#   default     = "PERSO_DRITON"
#   description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
# }


