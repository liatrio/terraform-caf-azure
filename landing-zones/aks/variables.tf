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

variable "name" {
  description = "A prefix used for resources"
}

variable "pool_name" {
  default     = "default"
  description = "The name of the default_node pool"
}

variable "node_count" {
  default     = "2"
  description = "The number of nodes"
}

variable "vm_size" {
  default     = "Standard_D2_v2"
  description = "The size of the VM"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "prefix" {
  description = "A prefix used for resources"
  type        = string
  default     = "caf"
}

variable "connectivity_hub_location" {
  description = "Supplies location of connectivity hub"
  type        = string
}
