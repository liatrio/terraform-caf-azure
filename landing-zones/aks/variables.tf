variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
}

variable "vnet_address_range" {
  description = "The CIDR address range of the vnet"
  type        = string
}

variable "name" {
  description = "A prefix used for resources"
}

variable "pool_name" {
  default     = "default"
  description = "The name of the default_node pool"
}

variable "node_count_min" {
  description = "Minimum node count"
  type        = number
  default     = 2
}

variable "node_count_max" {
  description = "Maximum node count"
  type        = number
  default     = 3
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
