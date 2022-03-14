variable "target_management_group_id" {
  type        = string
  description = "Management group to apply policy set to"
}

variable "policy_set_ids" {
  type        = list(string)
  description = "Full IDs of policy sets to apply"
}

