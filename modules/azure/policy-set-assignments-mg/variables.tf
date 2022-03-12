variable "target_management_group_id" {
  type = string
}

variable "policy_set_ids" {
  type = list(string)
}

variable "policy_management_group_id" {
  type    = string
  default = null
}
