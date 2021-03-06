variable "prefix" {
  type = string
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

variable "vpn_service_principal_application_id" {
  type        = string
  description = "The ApplicationID of the Azure VPN service principal, used for AAD authentication to the point-to-site VPN"
}

variable "landing_zone_mg" {
  type = map(object({
    display_name = string
    policy_ids   = list(map(string))
  }))
  default     = {}
  description = "Dynamic landing zone creation"
}

variable "foundation_name" {
  type    = string
  default = "Foundation"
}

variable "foundation_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "platform_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "connectivity_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "identity_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "management_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "landing_zones_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "shared_svc_policy_sets" {
  type    = list(map(string))
  default = []
}

variable "root_dns_zone" {
  type = string
}

variable "root_dns_tags" {
  type = map(any)
}

variable "default_policies_enabled" {
  type    = string
  default = true
}

variable "log_analytics_ws_sku" {
  type        = string
  description = "SKU for the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "enable_ms_defender" {
  type        = bool
  description = "Feature flag to enable MS Defender for Cloud"
  default     = false
}

variable "enable_firewall" {
  type        = bool
  description = "Enables the firewall and its association with the virtual hub"
  default     = false
}

variable "firewall_sku_tier" {
  type        = string
  description = "SKU to use for the Firewall"
  default     = "Standard"
}

variable "enable_point_to_site_vpn" {
  type        = bool
  description = "If enabled, creates User Point to Site VPN configuration in CAF foundation."
  default     = true
}

variable "enable_budget_alerts" {
  type        = bool
  description = "Feature flag to enable billing alerts"
  default     = false
}

variable "slack_webhook_url" {
  type        = string
  description = "URL or a Slack webhook to send the Slack alerts to"
  default     = ""
}

variable "teams_webhook_url" {
  type    = string
  default = ""
}

variable "budgets" {
  type    = map(any)
  default = {}
}

variable "budget_tags" {
  type    = map(any)
  default = {}
}
