variable "company_name" {
  type = string
}

variable "group_prefix" {
  type = string
}

variable "management_id" {
  type = string
}

variable "management_policy_sets" {
  type    = list(string)
  default = []
}
