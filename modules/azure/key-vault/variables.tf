variable "environment" {
  description = "The env dev, qa, prod that the key vault is in"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "name" {
  description = "Unique resources name"
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name the resources in this module"
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}

variable "workload" {
  description = "workload/application this key vault is being deployed for"
  type        = string
}

variable "service_endpoints_subnet_id" {
  description = "Subnet ID in which to place Key Vault private endpoint"
  type        = string
}

variable "connectivity_resource_group_name" {
  type = string
}

variable "enabled_for_disk_encryption" {
  description = "Whether or not to allow the Azure Disk Encryption to retrieve certs stored in key vault"
  type        = bool
  default     = true
}

variable "vault_keys" {
  description = "A map of keys to generate in the Azure Key Vault"
  type        = map(any)
  default     = {}
}
