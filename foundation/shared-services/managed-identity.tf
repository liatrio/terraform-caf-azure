data "azurerm_subscription" "current" {
}

data "azurerm_subscription" "connectivity" {
  provider = azurerm.connectivity
}

resource "azurerm_user_assigned_identity" "shared_services_msi" {
  resource_group_name = azurerm_resource_group.lz_resource_group.name
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

resource "azurerm_user_assigned_identity" "cert_mgr_dns_contributor" {
  resource_group_name = azurerm_resource_group.lz_resource_group.name
  location            = var.location

  name = "${var.prefix}-${var.name}-cert-mgr-msi"
}

resource "azurerm_role_assignment" "connectivity_public_dns_contributor" {
  provider             = azurerm.connectivity
  scope                = var.public_dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_mgr_dns_contributor.principal_id
}
