variable "group_prefix" {
  type    = string
  default = "caf"
}

variable "billing_account_name" {
  type = string
}

variable "billing_profile_name" {
  type = string

}

variable "invoice_section_name" {
  type = string

}

variable "shared_services" {
  type = map(any)
}
