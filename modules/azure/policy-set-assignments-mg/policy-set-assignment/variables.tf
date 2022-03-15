variable "target_management_group_id" {
  type        = string
  description = "Management group to apply policy set to"
}

variable "policy_set_id" {
  type        = string
  description = "Full ID of policy set to apply"
}

variable "policy_parameters" {
  type        = string
  description = "Optional parameters for policies"
}
