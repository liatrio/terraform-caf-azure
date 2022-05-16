variable "app_service_list" {
    type = list(map(string))
    default = [
        {
            name = "testfe"
            tier = "Standard"
            type = "Linux"
            sku  = "S1"
        },
        {
            name = "testapi"
            tier = "Standard"
            type = "Linux"
            sku  = "S1"
        }
    ]
}

variable "app_conf_feature_list" {
    type = list(map(string))
    default = [
        {
            name = "test_conf_1"
            description = "This is a test configuration value"
            enabled = false
        },
        {
            name = "test_conf_2"
            description = "This is a test configuration value v2"
            enabled = false
        }
    ]
}

variable "env" {
  description = "The env dev, qa, prod that the key vault is in"
  type        = string
}

variable "short_location" {
  description = "The truncated location name eg. cus, eus, wus, etc."
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "workload" {
  description = "workload/application this key vault is being deployed for"
  type        = string
}

variable "vnet_rg_name" {
  description = "Name of Resource Group that contains the Vnet/Subnet for Private Endpoint creation"
  type        = string
}

variable "vnet_name" {
  description = "name of the virtual network that houses the private endpoint subnet"
  type        = string
}

variable "subnet_name" {
  description = "private endpoint subnet name"
  type        = string
}

variable "dns_rg_name" {
  description = "Name of the RG that houses the Private DNS Zone for azurewebsites.net"
  type        = string
}
