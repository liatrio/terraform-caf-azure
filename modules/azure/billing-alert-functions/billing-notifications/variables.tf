variable "budgets" {
  type = map(any)
}

variable "location" {
  type = string
}

variable "func_identifier" {
  type = string
}

variable "contact_groups" {
  type = list(any)
}
