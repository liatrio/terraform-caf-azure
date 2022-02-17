locals {
  // https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant#enable-authentication
  azure_vpn_app_id = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

resource "azuread_service_principal" "azure_vpn" {
  application_id = local.azure_vpn_app_id

  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
}

data "azuread_service_principal" "windows_azure_active_directory" {
  display_name = "Windows Azure Active Directory"
}

resource "azuread_service_principal_delegated_permission_grant" "azure_vpn" {
  service_principal_object_id          = azuread_service_principal.azure_vpn.object_id
  resource_service_principal_object_id = data.azuread_service_principal.windows_azure_active_directory.object_id
  claim_values                         = ["User.Read", "User.ReadBasic.All"]
}

resource "azuread_conditional_access_policy" "vpn_require_mfa" {
  display_name = "VPN Require MFA"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    applications {
      included_applications = [
        azuread_service_principal.azure_vpn.application_id
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
