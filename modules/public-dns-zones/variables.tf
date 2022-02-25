variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "root_dns_zone" {
  type        = string
  description = "root dns zone"
}

variable "tags" {
  default = {}
}
