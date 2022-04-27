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
