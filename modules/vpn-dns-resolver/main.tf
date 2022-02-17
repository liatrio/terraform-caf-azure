terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.96.0"
    }
  }
}

locals {
  name = var.prefix == "" ? "vpn-dns-resolver" : format("%s-vpn-dns-resolver", var.prefix)
}

resource "azurerm_subnet" "coredns_subnet" {
  name                 = local.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  address_prefixes = [
    var.subnet_cidr
  ]

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_network_profile" "coredns_network_profile" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "nic"

    ip_configuration {
      name      = "ip-config"
      subnet_id = azurerm_subnet.coredns_subnet.id
    }
  }

  tags = var.tags
}

resource "azurerm_container_group" "coredns" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "linux"

  ip_address_type    = "private"
  network_profile_id = azurerm_network_profile.coredns_network_profile.id

  exposed_port {
    port     = 53
    protocol = "UDP"
  }

  exposed_port {
    port     = 8181
    protocol = "TCP"
  }

  container {
    name   = "coredns"
    image  = "coredns/coredns:1.9.0"
    cpu    = "0.1"
    memory = "0.1"

    commands = ["/coredns", "-conf", "/config/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    ports {
      port     = 8181
      protocol = "TCP"
    }

    volume {
      mount_path = "/config"
      name       = "config"

      # this isn't really a secret, but this is an easy way to specify an inline file for the container to use
      secret = {
        "Corefile" = base64encode(templatefile("${path.module}/Corefile.tpl", {
          upstream_dns_server = var.upstream_dns_server
        }))
      }
    }
  }

  tags = var.tags
}
