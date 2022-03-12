variable "identity_id" {
  type = string
}

variable "identity_policy_sets" {
  type    = list(string)
  default = []
}

variable "group_prefix" {
  type = string
}
