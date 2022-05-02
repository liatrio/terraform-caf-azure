variable "func_identifier" {
  type = string
}

variable "subscriptions" {
  type = map(any)
}

variable "to_provision" {
  type    = bool
  default = true
}

variable "resource_group_name" {
  type = string
}

variable "default_hostname" {
  type = string
}

variable "budget_time_start" {
  type = string
}

variable "budget_amounts" {
  type    = map(any)
  default = { "default" : 1000 }
}

variable "budget_time_grains" {
  description = "A choice of time grain, options are: Annually, BillingAnnual, BillingMonth, BillingQuarter, Monthly, and Quarterly"
  type        = map(any)
  default     = { "default" : "Monthly" }
}

variable "budget_operator" {
  description = "A choice of operator, options are: EqualTo, GreaterThan, or GreaterThanOrEqualTo"
  type        = map(any)
  default     = { "default" = "EqualTo" }
}

variable "budget_threshold" {
  type    = map(any)
  default = { "default" = 80.0 }
}

variable "enable_slack" {
  type    = bool
  default = false
}

variable "enable_teams" {
  type    = bool
  default = false
}
