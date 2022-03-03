data "azurerm_subscription" "current" {
}

data "azurerm_subscription" "connectivity" {
  provider = azurerm.connectivity
}

resource "azurerm_user_assigned_identity" "shared_services_msi" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  name = "${var.prefix}-${var.name}-msi"
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

resource "azurerm_user_assigned_identity" "cert_manager" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  name = "${var.prefix}-${var.name}-cert-manager-msi"
}

resource "azurerm_role_assignment" "dns_contributor" {
  provider             = azurerm.connectivity
  scope                = module.shared_services_public_dns_zone.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}