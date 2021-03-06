variable "name" {
  description = "Unique resources name for AKS cluster"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "vnet_address_range" {
  description = "The CIDR expression (e.g. '10.0.0.0/8') giving an IPv4 network address range for the vnet. Should be a /16 or larger to allow room for AKS cluster operations using Azure CNI"
  type        = string
  validation {
    condition     = cidrnetmask(var.vnet_address_range) == "255.255.0.0"
    error_message = "The vnet_address_range must be a /16 (i.e. Subnet mask of 255.255.0.0)."
  }
}

variable "connectivity_dns_servers" {
  type        = list(string)
  description = "List of IP addresses to set as vnet DNS servers"
  default     = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name the resources in this module"
}

variable "include_rules_allow_web_inbound" {
  type        = bool
  description = "Flag to enable web hosting NSG rules. Defaults to false"
  default     = false
}
