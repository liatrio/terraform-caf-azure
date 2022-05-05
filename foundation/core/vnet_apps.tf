resource "azurerm_network_security_group" "connectivity_security_group" {
  provider            = azurerm.connectivity
  name                = "nsg-base-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.caf_connectivity.name
}

resource "azurerm_virtual_network" "connectivity_vnet" {
  provider            = azurerm.connectivity
  name                = "vnet-connectivity-apps-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.caf_connectivity.name
  address_space = [
    var.connectivity_apps_address_cidr
  ]
}

resource "azurerm_virtual_hub_connection" "connectivity_hub_connection" {
  provider                  = azurerm.connectivity
  name                      = "vhub-connectivity-${var.location}"
  virtual_hub_id            = azurerm_virtual_hub.caf_hub.id
  remote_virtual_network_id = azurerm_virtual_network.connectivity_vnet.id
}

/*
  We expect to receive a /24 for the vnet that will contain applications that support the connectivity subscription.
  By dividing each application into its own /29, we will be able to house up to 32 applications in this way.
  This will allow for each supporting application to have roughly 6 hosts, which should hopefully be enough.
  Applications that need more address space can always allocate a /28 instead.

  The locals below will divide the /24 for the vnet into the corresponding /29 subnets.

  We can use the `cidrsubnet` function to help compute these values. As an example:

  cidrsubnet(var.connectivity_apps_address_cidr, 5, 0) -> returns the first /29 within the vnet's address space
  cidrsubnet(var.connectivity_apps_address_cidr, 5, 1) -> returns the second /29 within the vnet's address space
*/

locals {
  coredns_subnet_cidr = cidrsubnet(var.connectivity_apps_address_cidr, 5, 0)
}
