# Code adapted from:
# https://github.com/dzeyelid/azure-cost-alert-webhook-to-slack/blob/main/iac/terraform/modules/mediation_functions/variables.tf

variable "func_identifier" {
  type = string
}

variable "location" {
  type = string
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

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_primary_key" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "storage_blob_name" {
  type = string
}

variable "storage_blob_sas" {
  type = string
}
