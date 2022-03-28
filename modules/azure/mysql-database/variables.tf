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
  type        = string
  description = "prefix"
}

variable "ss_kv" {
  type        = string
  description = "shared service Key Vault"
}

variable "ss_rg" {
  type        = string
  description = "shared service kv RG"
}

variable "environment" {
  type        = string
  description = "environment shortname"
}
