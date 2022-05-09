# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/variables.tf

variable "func_identifier" {
  type = string
}

variable "subscriptions" {
  type = map(any)
}

variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "storage" {
  type = object({
    tier             = string
    replication_type = string
  })
  default = {
    tier             = "Standard"
    replication_type = "LRS"
  }
}

variable "app_service_plan" {
  type = object({
    tier = string
    size = string
  })
  default = {
    tier = "Dynamic"
    size = "Y1"
  }
}

variable "slack_webhook_url" {
  type = string
}

variable "teams_webhook_url" {
  type = string
}

variable "budget_time_start" {
  type = string
}

variable "budget_amounts" {
  type = map(any)
}

variable "budget_time_grains" {
  description = "A choice of time grain, options are: Annually, BillingAnnual, BillingMonth, BillingQuarter, Monthly, and Quarterly"
  type        = map(any)
}

variable "budget_operator" {
  description = "A choice of operator, options are: EqualTo, GreaterThan, or GreaterThanOrEqualTo"
  type        = map(any)
}

variable "budget_threshold" {
  type = map(any)
}

variable "budget_tags" {
  type = map(any)
}