variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type        = string
  description = "storage account name must not exceed 18 characters"
}

variable "prefix" {
    type = string
    description = "prefix"
}
