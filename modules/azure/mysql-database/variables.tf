variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Application Name"
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
