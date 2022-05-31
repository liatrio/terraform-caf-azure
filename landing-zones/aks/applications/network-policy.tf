module "network_policy" {
  source = "../../../modules/kubernetes/network-policies"

  default_deny        = var.network_policy_default_deny
  excluded_namespaces = var.network_policy_excluded_namespaces
}