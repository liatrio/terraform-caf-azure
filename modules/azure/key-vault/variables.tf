variable "env" {
  description = "The env dev, qa, prod that the key vault is in"
  type        = string
}

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

variable "certificate_permissions" {
  description = "A list of certificate permissions for key vault to grant to object_id and application_id"
  type        = list(string)
  default     = []
}

variable "key_permissions" {
  description = "A list of key permissions for key vault to grant to object_id and application_id"
  type        = list(string)
  default     = []
}

variable "secret_permissions" {
  description = "A list of secret permissions permissions for key vault to grant to object_id and application_id"
  type        = list(string)
  default     = []
}

variable "storage_permissions" {
  description = "A list of storage permissions for key vault to grant to object_id and application_id"
  type        = list(string)
  default     = []
}

variable "application_id" {
  description = "The application ID to give to key vault when setting access policies"
  type        = string
  default     = null
}

variable "keyvault_group_object_id" {
  description = "OPTIONAL Object ID of AAD security group to which key vault access policies should be assigned"
  type        = string
  default     = null
}
