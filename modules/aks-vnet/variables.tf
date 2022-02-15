## Global
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "vnet_address_range" {
  description = "The address range of vnet"
  type        = string
}

variable "aks_subnet_address_range" {
  description = "The address range of the aks subnet"
  type        = string
}