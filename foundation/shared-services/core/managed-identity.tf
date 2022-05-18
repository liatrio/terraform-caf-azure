resource "azurerm_user_assigned_identity" "shared_services_msi" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  name = "uai-${var.prefix}-${local.shared_services_name}-msi-${var.env}-${var.location}"
}

resource "azurerm_role_assignment" "cluster_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Azure Kubernetes Service Contributor Role"
  principal_id         = azurerm_user_assigned_identity.shared_services_msi.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.shared_services_msi.principal_id
}

resource "azurerm_role_assignment" "subscription_connectivity_dns_contributor" {
  provider             = azurerm.connectivity
  scope                = data.azurerm_subscription.connectivity.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.shared_services_msi.principal_id
}

resource "azurerm_user_assigned_identity" "external_dns_pod_identity" {
  name                = "uai-${var.prefix}-external-dns-${var.env}-${var.location}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
}

resource "azurerm_role_assignment" "subscription_shared_services_reader" {
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.external_dns_pod_identity.principal_id
}

resource "azurerm_role_assignment" "subscription_shared_services_dns_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns_pod_identity.principal_id
}

resource "azurerm_user_assigned_identity" "cert_manager_pod_identity" {
  name                = "cert-manager-dns01"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
}

resource "azurerm_role_assignment" "cert_manager_dns_contributor" {
  scope                = module.shared_services_public_dns_zone.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager_pod_identity.principal_id
}

resource "azurerm_role_assignment" "cert_manager_internal_dns_contributor" {
  scope                = module.shared_services_internal_public_dns_zone.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager_pod_identity.principal_id
}

resource "azurerm_role_assignment" "aks_virtual_machine_contributor" {
  scope                = module.aks.cluster_node_resource_group
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.aks.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "aks_managed_identity_operator" {
  scope                = module.aks.cluster_node_resource_group
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "aks_managed_identity_operator_for_cert_manager_identity" {
  scope                = azurerm_user_assigned_identity.cert_manager_pod_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "aks_managed_identity_operator_for_external_dns_identity" {
  scope                = azurerm_user_assigned_identity.external_dns_pod_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.kubelet_identity_object_id
}
