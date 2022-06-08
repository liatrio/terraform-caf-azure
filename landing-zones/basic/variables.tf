variable "environment" {
  description = "The env dev, qa, prod that the lz is in"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
}

variable "vnet_address_range" {
  description = "The CIDR address range of the vnet"
  type        = string
}

variable "connectivity_dns_servers" {
  type        = list(string)
  description = "List of IP addresses to set as vnet DNS servers"
}

variable "name" {
  description = "A prefix used for resources"
}

variable "prefix" {
  description = "A prefix used for resources"
  type        = string
  default     = "caf"
}
variable "connectivity_resource_group_name" {
  type = string
}

variable "external_app" {
  type        = bool
  description = "If true the following occurs: enables web hosting ports 80 and 443 externally, creates public DNS zone, creates external wildcard cert"
  default     = false
}

variable "dns_zone_name" {
  type        = string
  description = "External Public Azure DNS zone name to associate with issuer helm chart"
}

variable "parent_dns_zone_name" {
  type        = string
  description = "Optional parent DNS zone name which causes a child zone to be created"
}

variable "enable_vnet_peering" {
  type        = bool
  description = "Feature flag to enable peering the lz VNet to a hub VNet"
  default     = false
}

variable "enable_virtual_hub_connection" {
  type        = bool
  description = "Feature flag to enable connecting the lz VNet to a virtual hub"
  default     = true
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

variable "workload" {
  type        = string
  description = "The workload that we are supporting"
}
