variable "location" {
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

variable "sub_id" {
  type        = string
  description = "Subscription ID for provisioning resources in Azure"
}

variable "connectivity_sub_id" {
  type        = string
  description = "Subscription ID for provisioning resources in Azure"
}

variable "service_principal" {
  type        = string
  description = "The name of the service principal"
  default     = ""
}
