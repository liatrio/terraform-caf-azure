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
  description = "The CIDR expression (e.g. '10.0.0.0/8') giving an IPv4 network address range for the vnet. Should be a /16 or larger to allow room for AKS cluster operations using Azure CNI"
  type        = string
  validation {
    condition     = split("/", var.vnet_address_range)[1] <= 16
    error_message = "The vnet_address_range must be at least size /16 (i.e. must use no more than 16 network bits)."
  }
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
