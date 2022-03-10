locals {
  shared_services_environment = split("-", var.name)[2]
}

#tfsec:ignore:azure-keyvault-no-purge
#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "key_vault" {
  name                      = "${var.prefix}-${local.shared_services_environment}"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true

  sku_name = "standard"
}
