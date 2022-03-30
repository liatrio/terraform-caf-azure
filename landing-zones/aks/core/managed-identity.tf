data "azurerm_subscription" "current" {
}

data "azurerm_subscription" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_private_dns_zone" "k8_connectivity" {
  provider            = azurerm.connectivity
  name                = var.connectivity_k8_private_dns_zone_name
  resource_group_name = var.connectivity_resource_group_name
}

resource "azurerm_user_assigned_identity" "aks_msi" {
  name                = "${var.prefix}-${var.name}-msi"
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
  name                = "${var.prefix}-${var.name}-cert-manager-msi"
  resource_group_name = azurerm_resource_group.lz_resource_group.name
  location            = var.location
}