variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type        = string
  description = "storage account name must not exceed 18 characters"

  validation {
    condition     = length(var.storage_account_name) < 18
    error_message = "Name must be less than 18 characters."
  }
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

variable "connectivity_resource_group" {
  type        = string
  description = "Name of Connectivity Resource Group"
}