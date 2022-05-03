variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
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

variable "enabled_for_disk_encryption" {
  description = "Whether or not to allow the Azure Disk Encryption to retrieve certs stored in key vault"
  type        = bool
  default     = true
}

variable "vault_key_to_create" {
  description = "A map with a key to generate in the Azure Key Vault"
  type        = map(any)
  default     = {}
}

variable "key_vault_id" {
  description = "The key vault ID to store the generated keys in."
  type        = string
}
