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
  type        = map(any)
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "autoscaler_config" {
  type        = map(string)
  description = "auto_scaler_profile config values"
  default     = {}
}

variable "kubernetes_managed_identity" {
  type        = string
  description = "kubernetes managed identity"
}

variable "private_dns_zone_id" {
  type        = string
  description = "private dns zone id"
}

variable "lz_resource_group" {
  type        = string
  description = "resource group for landing-zone"
}
