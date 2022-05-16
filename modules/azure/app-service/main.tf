terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
}

resource "azurerm_resource_group" "apprg" {
  name     = "rg-${var.workload}-${var.env}-${var.short_location}"
  location = var.location
}

resource "azurerm_service_plan" "app_service_list" {
  for_each            = var.app_service_list
  name                = "asp-${each.value["name"]}-${var.env}-${var.short_location}"
  resource_group_name = azurerm_resource_group.apprg.name
  location            = azurerm_resource_group.apprg.location
  os_type             = each.value["type"]
  sku_name            = each.value["sku"]
}

resource "azurerm_linux_web_app" "app_service_list" {
  for_each            = var.app_service_list
  name                = "as-${each.value["name"]}-${var.env}-${var.short_location}"
  resource_group_name = azurerm_resource_group.apprg.name
  location            = azurerm_resource_group.apprg.name
  service_plan_id     = azurerm_service_plan.app_service_list[each.value["name"]].id

  site_config {}
}

resource "azurerm_private_endpoint" "app_service_list" {
  for_each            = var.app_service_list
  name                = "pe-${each.value["name"]}-${var.env}-${var.short_location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.apprg.name
  subnet_id           = data.azurerm_subnet.pe.id

  private_dns_zone_group {
    name = "privatelink-dns-zones"

    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.dns.id
    ]
  }

  private_service_connection {
    name                           = "psc-${each.value["hane"]}-${var.env}-${var.short_location}"
    private_connection_resource_id = azurerm_linux_web_app.app_service_list[each.value["name"]].id
    is_manual_connection           = false
  }
}

resource "azurerm_app_configuration" "app_conf" {
  name                = "ac-${var.workload}-${var.env}-${var.short_location}"
  resource_group_name = azurerm_resource_group.apprg.name
  location            = var.location
}

resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.app_conf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_feature" "app_conf_feature_list" {
  for_each               = var.app_conf_feature_list
  configuration_store_id = azurerm_app_configuration.app_conf.id
  description            = each.value["description"]
  name                   = each.value["name"]
  label                  = var.env
  enabled                = each.value["enabled"]
}
