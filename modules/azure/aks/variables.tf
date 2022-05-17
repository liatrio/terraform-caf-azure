variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  type        = string
}

variable "name" {
  description = "Unique resources name for AKS cluster"
  type        = string
}

variable "pool_name" {
  description = "The name of the default_node pool"
  type        = string
}

variable "node_count_min" {
  description = "Minimum node count"
  type        = number
}

variable "node_count_max" {
  description = "Maximum node count"
  type        = number
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Vnet subnet ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "autoscaler_config" {
  type        = map(string)
  description = "auto_scaler_profile config values"
  default     = {}
}

variable "kubernetes_managed_identity" {
  type        = set(string)
  description = "kubernetes managed identity"
}

variable "private_dns_zone_id" {
  type        = string
  description = "private dns zone id"
}

variable "lz_resource_group" {
  type        = string
  description = "resource group for landing-zone"
}

variable "aks_service_subnet_cidr" {
  type        = string
  description = "Subnet carved from shared services vnet from which to assign aks service IPs"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "IP drawn from service address range to be used for cluster discover service (kube-dns)"
}

variable "log_analytics_workspace" {
  type        = string
  description = "Log analytics workspace to link the AKS cluster to"
}

variable "enable_aks_policy_addon" {
  type        = bool
  description = "Feature flag to enable AKS Policy Add On"
  default     = false
}

variable "aks_enable_disk_encryption" {
  type        = bool
  description = "Whether or not to enable disk encryption in the AKS Cluster"
  default     = true
}

variable "disk_encryption_set_id" {
  type        = string
  description = "The disk encryption set ID"
  default     = null

}

variable "environment" {
  type = string
  description =
}