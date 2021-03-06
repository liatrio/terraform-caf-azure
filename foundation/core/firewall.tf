resource "azurerm_firewall_policy" "firewall_policy" {
  count = var.enable_firewall ? 1 : 0

  name                = "afwp-${var.prefix}-${azurerm_resource_group.caf_connectivity.location}"
  provider            = azurerm.connectivity
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = var.location
  dns {
    proxy_enabled = true
    servers       = [module.dns_resolver.ip_address]
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  count = var.enable_firewall == true ? 1 : 0

  provider           = azurerm.connectivity
  name               = "wafrg-${var.prefix}-${azurerm_resource_group.caf_connectivity.location}"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
  priority           = 500
}

resource "azurerm_firewall" "firewall" {
  count = var.enable_firewall == true ? 1 : 0

  provider           = azurerm.connectivity
  name               = "afw-${var.prefix}-${azurerm_resource_group.caf_connectivity.location}"
  location           = var.location
  sku_name           = "AZFW_Hub"
  sku_tier           = var.firewall_sku_tier
  firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
  threat_intel_mode  = "Alert"
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.caf_hub.id
  }
  resource_group_name = azurerm_resource_group.caf_connectivity.name
}
