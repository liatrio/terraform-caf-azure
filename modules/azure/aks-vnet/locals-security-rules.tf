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
      include                    = true
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
      include                    = true
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
      include                    = true
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
      include                    = true
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
      include                    = true
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
      include                    = true
    }
    AllowWebHTTPInbound = {
      name                       = "AllowWebHTTPInbound"
      description                = "Allow inbound http traffic"
      priority                   = 2000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "AzureCloud"
      include                    = var.include_rules_allow_web_inbound
    }
    AllowWebHTTPSInbound = {
      name                       = "AllowWebHTTPSInbound"
      description                = "Allow inbound https traffic"
      priority                   = 2001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "AzureCloud"
      include                    = var.include_rules_allow_web_inbound
    }
  }
}
