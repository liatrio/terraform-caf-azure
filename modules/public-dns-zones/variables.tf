variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "azure_caf_root_dns" {
  type        = string
  description = "(optional) describe your variable"
}

variable "tags" {
  default = {}
}
