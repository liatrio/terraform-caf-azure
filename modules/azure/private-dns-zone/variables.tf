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

variable "dns_zone_name" {
  type = string
}
