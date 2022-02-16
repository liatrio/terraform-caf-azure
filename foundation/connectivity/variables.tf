variable "location" {
  type    = string
  default = "southcentralus"
}
variable "vhub_subnet_cidr" {
  type        = string
  description = "The subnet CIDR for the Virtual Hub"
}
variable "vpn_client_pool_subnet_cidr" {
  type        = string
  description = "The subnet CIDR for the VPN user pool"
}
variable "tenant_id" {
  type = string
}
variable "prefix" {
  type    = string
  default = "caf"
}
variable "vpn_service_principal_application_id" {
  type        = string
  description = "The ApplicationID of the Azure VPN service principal, used for AAD authentication to the point-to-site VPN"
}
