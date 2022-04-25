variable "slack_func_identifier" {
  type = string
}

variable "subscriptions" {
  type = map
}

variable "operator" {
  description = "A choice of operator, options are: EqualTo, GreaterThan, or GreaterThanOrEqualTo"
  type = string
  default = "EqualTo"
}

variable "amount" {
    type = number
    default = 1000
}

variable "time_grain" {
    description = "A choice of time grain, options are: Annually, BillingAnnual, BillingMonth, BillingQuarter, Monthly, and Quarterly"
    type = string
    default = "Monthly"
}

variable "threshold" {
  type = number
  default = 80.0
}

variable "to_provision" {
    type    = bool
    default = true
}
