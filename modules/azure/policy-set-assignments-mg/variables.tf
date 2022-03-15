variable "target_management_group_id" {
  type        = string
  description = "Management group to apply policy set to"
}

variable "policy_sets" {
  type        = list(map(any))
  description = "Full IDs of policy sets to apply along with required parameters"
}
