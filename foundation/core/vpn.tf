resource "azurerm_vpn_server_configuration" "vpn_server_config" {
  provider            = azurerm.connectivity
  count               = var.enable_point_to_site_vpn == true ? 1 : 0
  name                = "vpn-${var.prefix}-core-config-aad-${var.location}"
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  location            = azurerm_resource_group.caf_connectivity.location

  vpn_authentication_types = [
    "AAD"
  ]

  azure_active_directory_authentication {
    audience = azuread_service_principal.azure_vpn.application_id[0]
    issuer   = "https://sts.windows.net/${data.azurerm_client_config.default.tenant_id}/"
    tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.default.tenant_id}"
  }
}

resource "azurerm_point_to_site_vpn_gateway" "hub_vpn_gateway" {
  provider                    = azurerm.connectivity
  count                       = var.enable_point_to_site_vpn == true ? 1 : 0
  name                        = "cn-${var.prefix}-core-hub-vpn-gateway-${azurerm_resource_group.caf_connectivity.location}"
  location                    = azurerm_resource_group.caf_connectivity.location
  resource_group_name         = azurerm_resource_group.caf_connectivity.name
  virtual_hub_id              = azurerm_virtual_hub.caf_hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpn_server_config[0].id
  scale_unit                  = 1

  dns_servers = [
    module.dns_resolver.ip_address
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

locals {
  // https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant#enable-authentication
  azure_vpn_app_id = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

resource "azuread_service_principal" "azure_vpn" {
  count = var.enable_point_to_site_vpn == true ? 1 : 0

  application_id = local.azure_vpn_app_id

  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
}

data "azuread_service_principal" "windows_azure_active_directory" {
  count = var.enable_point_to_site_vpn == true ? 1 : 0

  display_name = "Windows Azure Active Directory"
}

resource "azuread_service_principal_delegated_permission_grant" "azure_vpn" {
  count = var.enable_point_to_site_vpn == true ? 1 : 0

  service_principal_object_id          = azuread_service_principal.azure_vpn.object_id[0]
  resource_service_principal_object_id = data.azuread_service_principal.windows_azure_active_directory.object_id[0]
  claim_values                         = ["User.Read", "User.ReadBasic.All"]
}

resource "azuread_conditional_access_policy" "vpn_require_mfa" {
  count = var.enable_point_to_site_vpn == true ? 1 : 0

  display_name = "VPN Require MFA"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    applications {
      included_applications = [
        azuread_service_principal.azure_vpn.application_id[0]
      ]
    }

    client_app_types = [
      "all"
    ]

    locations {
      included_locations = [
        "All"
      ]
    }

    platforms {
      included_platforms = [
        "all"
      ]
    }

    users {
      included_users = [
        "All"
      ]
    }
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}
