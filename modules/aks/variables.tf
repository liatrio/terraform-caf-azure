## Global
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "name" {
  description = "Unique resources name for AKS cluster"
  type        = string
}

variable "pool_name" {
  description = "The name of the default_node pool"
  type        = string
}

variable "node_count" {
  description = "The number of nodes"
  type        = number
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Vnet subnet ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map
  default     = {}
}