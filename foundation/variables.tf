variable "group_prefix" {
  type    = string
  default = "caf"
}

variable "location" {
  type = string
}

variable "virtual_hub_address_cidr" {
  type        = string
  description = "The network CIDR for the Virtual Hub"
}

variable "vpn_client_pool_address_cidr" {
  type        = string
  description = "The network CIDR for the VPN user pool"
}

variable "connectivity_apps_address_cidr" {
  type        = string
  description = "The network CIDR for applications that support the connectivity subscription. This should be a /24, so we can fit 32 /29s to accommodate supporting applications"
  validation {
    condition     = cidrnetmask(var.connectivity_apps_address_cidr) == "255.255.255.0"
    error_message = "The connectivity_apps_address_cidr value must be a /24."
  }
}

variable "tenant_id" {
  type        = string
  description = "Tenant to deploy CAF"
}

variable "vpn_service_principal_application_id" {
  type        = string
  description = "The ApplicationID of the Azure VPN service principal, used for AAD authentication to the point-to-site VPN"
}

variable "landing_zone_mg" {
  type = map(object({
    display_name = string
    policy_ids   = list(string)
  }))
  default     = {}
  description = "Dynamic landing zone creation"
}

variable "public_dns_root_zone" {
  type = string
}

variable "root_dns_tag" {
  type = map(any)
}
