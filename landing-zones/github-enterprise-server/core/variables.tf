variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}

variable "vnet_address_cidr" {
  description = "The address space of the vnet in CIDR notation"
  type        = string
  validation {
    condition     = cidrnetmask(var.vnet_address_cidr) == "255.255.255.0"
    error_message = "The vnet_address_range value must be a /24."
  }
}

variable "connectivity_dns_servers" {
  type        = list(string)
  description = "List of IP addresses to set as vnet DNS servers"
}

variable "connectivity_virtual_hub_name" {
  type        = string
  description = "The name of the virtual hub within the connectivity subscription"
}

variable "connectivity_resource_group" {
  type        = string
  description = "The name of the connectivity resource group"
}

variable "github_enterprise_server_version" {
  type        = string
  description = "The version of GitHub Enterprise Server to use as the base image"
}

variable "github_enterprise_server_hostname" {
  type        = string
  description = "Hostname of GHE server appliance"
}

variable "github_actions_storage_account_name" {
  type        = string
  description = "The name of the storage account to use for GitHub Actions"
}
