variable "namespace" {
  description = "Cluster namespace in which to create the certificate"
}

variable "name" {
  description = "Release name to apply to the helm chart for the certificate, and thus also the certificate and its secret"
}

variable "domain" {
  description = "DNS domain for which to generate a wildcard certificate"
}

variable "issuer_name" {
  description = "Name of issuer to use to generate certificate"
  default     = "letsencrypt-dns"
}

variable "issuer_kind" {
  default = "Issuer"
}

variable "altname" {
  default = ""
}

variable "wait_for_cert" {
  default = "false"
}
