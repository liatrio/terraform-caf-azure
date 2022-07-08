variable "location" {}

variable "storage_account_name" {
  default = "caftfstate"
}

variable "storage_account_container" {
  default = "terraform-caf-azure"
}
