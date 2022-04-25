variable "environment" {
  description = "Name of the shared services environment (prod, staging, etc)"
  type        = string
}

variable "prefix" {
  description = "A prefix used for resources"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
  default     = "centralus"
}

variable "vnet_address_range" {
  description = "The CIDR address range of the vnet"
  type        = string
}

variable "connectivity_dns_servers" {
  type        = list(string)
  description = "List of IP addresses to set as vnet DNS servers"
}

variable "pool_name" {
  type        = string
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
  type        = string
  default     = "Standard_D2_v2"
  description = "The size of the VM"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "parent_dns_zone_name" {
  type        = string
  description = "Optional parent DNS zone name which causes a child zone to be created"
}

variable "connectivity_resource_group_name" {
  type        = string
  description = "Connectivity resource group name"
}

variable "public_dns_zone_name" {
  type        = string
  description = "public dns zone to create"
}

variable "enable_ms_defender" {
  type        = bool
  description = "Feature flag to enable MS Defender for Cloud"
  default     = false
}

variable "enable_aks_policy_addon" {
  type        = bool
  description = "Feature flag to enable AKS Policy Add On"
  default     = false
}

variable "ms_defender_enabled_resources" {
  type        = map(any)
  description = "Enables MS Defender for resources when resource type name = true (e.g. 'Containers' = true)"
  default     = {}
}
