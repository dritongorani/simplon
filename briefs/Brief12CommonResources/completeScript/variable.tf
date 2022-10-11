

variable "rg_name" {
  type = string
  description = "Enter your resource group name"
}

variable "mariadb_server_name" {
  type = string
  description = "Enter a server name"
}

variable "mariadb_admin_name" {
  type = string
  description = "Enter your username"
}

variable "mariadb_admin_password" {
  type = string
  description = "Enter your password"
}

variable "database_name" {
  type = string
  description = "Enter your database_name"
}

variable "number_of_database" {
  type = number
  description = "Enter number of database"
}