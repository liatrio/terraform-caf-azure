variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  default = {}
}

variable "linked_virtual_network_id" {
  type = string
}

variable "azure_paas_private_dns_zones" {
  type = map(string)
}
