variable "prefix" {
  type    = string
  default = ""
}

variable "upstream_dns_server" {
  type        = string
  description = "The IP address of the DNS server to proxy requests to. Defaults to Azure's special internal DNS server"
  default     = "168.63.129.16" # https://docs.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "tags" {
  default = {}
}

variable "subnet_cidr" {
  type = string
}
