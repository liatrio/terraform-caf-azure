variable "namespace" {
  default = "default"
}

variable "cert_mgr_dns_contributor_client_id" {
  type = string
}

variable "azure_resource_group" {
  type = string
}

variable "shared_services_cluster_host" {
  type = string
}

variable "cluster_client_certificate" {
  type = string
}

variable "cluster_client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}
