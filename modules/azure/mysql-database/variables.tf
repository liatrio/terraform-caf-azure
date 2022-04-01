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

variable "mssql_enabled" {
  type        = bool
  default     = 0
  description = "Change value to 1 to enable mssql paas build"
}

variable "mssql_database_map" {
  type        = "map"
  description = "Map of MS Sql Databases with db number, db name, collation, size, and sku"
}

