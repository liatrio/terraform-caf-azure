variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type        = string
  description = "storage account name must not exceed 18 characters"

  validation {
    condition     = length(var.storage_account_name) < 18
    error_message = "Name must be less than 18 characters"
  }
}

variable "prefix" {
  type        = string
  description = "prefix"
}

variable "shrdsvcs_kv" {
  type        = string
  description = "shared service Key Vault"
}

variable "shrdsvcs_rg" {
  type        = string
  description = "shared service kv RG"
}

variable "environment" {
  type        = string
  description = "environment shortname"
}
