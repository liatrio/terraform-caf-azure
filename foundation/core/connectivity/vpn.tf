module "vpn_dns_resolver" {
  source = "../../modules/azure/vpn-dns-resolver"

  location             = var.location
  resource_group_name  = azurerm_resource_group.caf_connectivity.name
  virtual_network_name = azurerm_virtual_network.connectivity_vnet.name
  subnet_cidr          = local.coredns_subnet_cidr
}

resource "azurerm_vpn_server_configuration" "vpn_server_config" {
  name                = "${var.prefix}-vpn-server-config-aad"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location
  vpn_authentication_types = [
    "AAD"
  ]

  azure_active_directory_authentication {
    audience = var.vpn_service_principal_application_id
    issuer   = "https://sts.windows.net/${var.tenant_id}/"
    tenant   = "https://login.microsoftonline.com/${var.tenant_id}"
  }
}

resource "azurerm_point_to_site_vpn_gateway" "hub_vpn_gateway" {
  name                        = "${var.prefix}-hub-vpn-gateway-${azurerm_resource_group.caf_connectivity.location}"
  location                    = azurerm_resource_group.caf_connectivity.location
  resource_group_name         = azurerm_resource_group.caf_connectivity.name
  virtual_hub_id              = azurerm_virtual_hub.caf_hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpn_server_config.id
  scale_unit                  = 1

  dns_servers = [
    module.vpn_dns_resolver.ip_address
  ]

  connection_configuration {
    name                      = "hub-vpn-gateway-config"
    internet_security_enabled = true

    vpn_client_address_pool {
      address_prefixes = [
        var.vpn_client_pool_address_cidr
      ]
    }
  }
}
