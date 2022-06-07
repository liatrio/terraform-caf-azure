locals {
  subnet_prefixes                        = cidrsubnets(var.vnet_address_cidr, 1, 4)
  github_actions_runners_subnet_prefix   = local.subnet_prefixes[0]
  github_enterprise_server_subnet_prefix = local.subnet_prefixes[1]

  // the first four hosts of a subnet are reserved by azure
  github_enterprise_server_private_ip_address = cidrhost(local.github_enterprise_server_subnet_prefix, 4)
}

data "azurerm_virtual_hub" "connectivity_hub" {
  provider            = azurerm.connectivity
  name                = var.connectivity_virtual_hub_name
  resource_group_name = var.connectivity_resource_group
}

module "vnet" {
  source = "registry.terraform.io/Azure/vnet/azurerm"

  vnet_name           = "github-enterprise-vnet"
  resource_group_name = azurerm_resource_group.github_enterprise_server.name

  address_space = [
    var.vnet_address_cidr
  ]
  subnet_prefixes = [
    local.github_actions_runners_subnet_prefix,
    local.github_enterprise_server_subnet_prefix
  ]
  subnet_names = [
    "github-actions-runners-snet",
    "github-enterprise-server-snet"
  ]
  subnet_service_endpoints = {
    "github-actions-runners-snet" : ["Microsoft.Storage"],
    "github-enterprise-server-snet" : ["Microsoft.Storage"]
  }
  subnet_enforce_private_link_endpoint_network_policies = {
    "github-actions-runners-snet" : false,
    "github-enterprise-server-snet" : false,
  }
  subnet_enforce_private_link_service_network_policies = {
    "github-actions-runners-snet" : false,
    "github-enterprise-server-snet" : false,
  }

  dns_servers = var.connectivity_dns_servers

  tags = var.tags

  depends_on = [
    azurerm_resource_group.github_enterprise_server
  ]
}

resource "azurerm_virtual_hub_connection" "connectivity_hub_connection" {
  provider                  = azurerm.connectivity
  name                      = "ghe-server-virtual-hub-connection"
  virtual_hub_id            = data.azurerm_virtual_hub.connectivity_hub.id
  remote_virtual_network_id = module.vnet.vnet_id
}
