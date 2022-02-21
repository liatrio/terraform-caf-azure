variable "company_name" {
  type = string
}

variable "foundation_name" {
  type    = string
  default = "Foundation"
}

variable "group_prefix" {
  type = string
}

variable "connectivity_id" {
  type = string
}

variable "identity_id" {
  type = string
}

variable "management_id" {
  type = string
}

variable "landing_zone_mg" {
  type = map(object({
    display_name = string
    policy_ids   = list(string)
  }))
}
