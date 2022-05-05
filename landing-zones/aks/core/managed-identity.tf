resource "azurerm_user_assigned_identity" "aks_msi" {
  name                = "${var.prefix}-${var.name}-msi-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.lz_resource_group.name
  location            = var.location
}

resource "azurerm_role_assignment" "cluster_contributor" {
  scope                = module.aks.cluster_id
  role_definition_name = "Azure Kubernetes Service Contributor Role"
  principal_id         = azurerm_user_assigned_identity.aks_msi.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = module.aks_vnet.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_msi.principal_id
}

resource "azurerm_role_assignment" "subscription_connectivity_dns_contributor" {
  provider             = azurerm.connectivity
  scope                = data.azurerm_private_dns_zone.k8_connectivity.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_msi.principal_id
}

resource "azurerm_user_assigned_identity" "cert_manager_pod_identity" {
  name                = "${var.prefix}-${var.name}-cert-manager-msi-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.lz_resource_group.name
  location            = var.location
}

resource "azurerm_user_assigned_identity" "external_dns_pod_identity" {
  count = var.external_app ? 1 : 0

  name                = "${var.prefix}-external-dns-msi-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.lz_resource_group.name
  location            = var.location
}

resource "azurerm_role_assignment" "resource_group_dns_reader" {
  count = var.external_app ? 1 : 0

  scope                = azurerm_resource_group.lz_resource_group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.external_dns_pod_identity[0].principal_id
}

resource "azurerm_role_assignment" "subscription_dns_contributor" {
  count = var.external_app ? 1 : 0

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.external_dns_pod_identity[0].principal_id
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
  count = var.external_app ? 1 : 0

  scope                = azurerm_user_assigned_identity.external_dns_pod_identity[0].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.kubelet_identity_object_id
}
