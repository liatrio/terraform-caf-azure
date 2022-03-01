# Creates Identity
resource "azurerm_user_assigned_identity" "cert_mgr_dns_identity" {
  name                = "cert-manager-dns01"
  resource_group_name = var.lz_resource_group
  location            = var.location
}

# Creates Role Assignment
resource "azurerm_role_assignment" "cert_mgr_dns_contributor" {
  scope                = var.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_mgr_dns_identity.principal_id
}
