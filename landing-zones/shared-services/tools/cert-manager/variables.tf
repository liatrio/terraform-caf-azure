variable "namespace" {
  default = "default"
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
  default     = "centralus"
}

variable "lz_resource_group" {
  type        = string
  description = "resource group for landing-zone"
}

variable "dns_zone_id" {
  type        = string
  description = "Public DNS zone ID to assign to cert manager"
}
