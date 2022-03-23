variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID to associate with issuer helm chart"
}
variable "aad_pod_identity_client_id" {
  type        = string
  description = "AAD Pod Identities managed identity client ID"
}

variable "aad_pod_identity_resource_id" {
  type        = string
  description = "AAD Pod Identities managed identity resource ID"
}
