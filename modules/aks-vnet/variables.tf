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

variable "aks_subnet_address_range" {
  description = "The address range of the aks subnet"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}