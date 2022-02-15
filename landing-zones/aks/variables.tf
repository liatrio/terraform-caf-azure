variable "resource_group_name" {
  description = "The name of the Azure resource group"
}

variable "location" {
  default     = "eastus"
  description = "The Azure Region in which all resources should be provisioned"
}

variable "vnet_address_range" {
  description = "The address range of vnet"
}

variable "aks_subnet_address_range" {
  description = "The address range of the aks subnet"
}

variable "prefix" {
  description = "A prefix used for resources"
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
}

variable "pool_name" {
  default     = "default"
  description = "The name of the default_node pool"
}

variable "node_count" {
    default = "2"
    description = "The number of nodes"
}

variable "vm_size" {
    default = "Standard_D2_v2"
    description = "The size of the VM"
}

