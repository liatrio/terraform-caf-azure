# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/variables.tf

variable "func_identifier" {
  type = string
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

variable "budget_tags" {
  type = map(any)
}

variable "budgets" {
  type = map(any)
}

variable "sas_time_start" {
  type = string
}

variable "sas_time_end" {
  type = string
}
