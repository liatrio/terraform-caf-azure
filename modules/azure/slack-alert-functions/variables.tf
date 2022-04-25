# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/variables.tf

variable "slack_func_identifier" {
  type = string
}

variable "subscriptions" {
  type = map
}

variable "location" {
  type    = string
  default = "westus"
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

variable "to_provision" {
  type    = bool
  default = true
}
