locals {
  nsgrules = {
    AllowVnetInBound = {
      name                       = "AllowVnetInBound"
      description                = "Allow inbound traffic from all VMs in VNET"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    AllowVnetOutBound = {
      name                       = "AllowVnetOutBound"
      description                = "Allow outbound traffic from all VMs to all VMs in VNET"
      priority                   = 4000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    AllowAzureLoadBalancerInBound = {
      name                       = "AllowAzureLoadBalancerInBound"
      description                = "Allow inbound traffic from azure load balancer"
      priority                   = 4001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    AllowInternetOutBound = {
      name                       = "AllowInternetOutBound"
      description                = "Allow outbound traffic from all VMs to Internet"
      priority                   = 4001
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
    DenyAllOutBound = {
      name                       = "DenyAllOutBound"
      description                = "Deny all outbound traffic"
      priority                   = 4050
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    DenyAllInBound = {
      name                       = "DenyAllInboundTraffic"
      description                = "Deny all inbound traffic"
      priority                   = 4050
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
