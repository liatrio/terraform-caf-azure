variable "resource_group_name" {
  type = string
}

variable "root_dns_zone" {
  type = string
}

variable "tags" {
  default = {}
}

variable "parent_dns_zone_resource_group_name" {
  default = ""
  type    = string
}

variable "parent_dns_zone_name" {
  type    = string
  default = ""
}
