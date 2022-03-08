variable "name" {
  description = "Unique resources name for AKS cluster"
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

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}

variable "lz_resource_group" {
  type        = string
  description = "resource group name for landing-zone"
}
