locals {
  keyvault_group_object_id = var.keyvault_group_object_id != null ? var.keyvault_group_object_id : data.azurerm_client_config.current.object_id
}
