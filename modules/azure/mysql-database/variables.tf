variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Application Name"

  validation {
    condition     = length(var.app_name) < 17
    error_message = "Name must be less than 17 characters."
  }
}

variable "shared_services_keyvault" {
  type        = string
  description = "shared service Key Vault"
}

variable "shared_services_resource_group" {
  type        = string
  description = "shared service kv RG"
}

variable "environment" {
  type        = string
  description = "environment shortname"
}

variable "vnet_name" {
  type        = string
  description = "Name assigned to VNET"
}

variable "privatelink_mysql_dns_zone" {
  type        = string
  description = "Privatelink DNS zone for mysql"
}

variable "connectivity_resource_group_name" {
  type        = string
  description = "Connectivity resource group"
}

variable "database_password_change_date" {
  type        = string
  description = "Tracks database password change date in YYYY-MM-DD format. Changing this value causes a new random password to be generated."
}
