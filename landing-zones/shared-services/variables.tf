variable "name" {
  type = string
}

variable "prefix" {
  description = "A prefix used for resources"
  type        = string
  default     = "caf"
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
  default     = "centralus"
}

variable "vnet_address_range" {
  description = "The address range of vnet"
  type        = string
}

variable "aks_subnet_address_range" {
  description = "The address range of the aks subnet"
  type        = string
}

variable "pool_name" {
  type        = string
  default     = "default"
  description = "The name of the default_node pool"
}

variable "node_count_min" {
  description = "Initial and minimum node count"
  type        = number
  default     = 2
}

variable "node_count_max" {
  description = "Maximum node count"
  type        = number
  default     = 3
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2_v2"
  description = "The size of the VM"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}
