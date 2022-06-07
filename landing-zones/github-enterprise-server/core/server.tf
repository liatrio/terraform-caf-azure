resource "random_password" "admin_password" {
  length = 24
}

resource "azurerm_network_interface" "github_enterprise_server" {
  name                = "github-enterprise-server-nic"
  location            = azurerm_resource_group.github_enterprise_server.location
  resource_group_name = azurerm_resource_group.github_enterprise_server.name

  ip_configuration {
    name                          = "nic"
    subnet_id                     = module.vnet.vnet_subnets[1]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.github_enterprise_server_private_ip_address
  }
}

resource "azurerm_virtual_machine" "github_enterprise_server" {
  location            = azurerm_resource_group.github_enterprise_server.location
  name                = "github-enterprise-server"
  resource_group_name = azurerm_resource_group.github_enterprise_server.name

  network_interface_ids = [azurerm_network_interface.github_enterprise_server.id]
  vm_size               = "Standard_E4bds_v5"

  storage_image_reference {
    publisher = "GitHub"
    offer     = "GitHub-Enterprise"
    sku       = "GitHub-Enterprise"
    version   = var.github_enterprise_server_version
  }

  storage_os_disk {
    name          = "ghe-server-root-disk"
    create_option = "FromImage"
    disk_size_gb  = 200
  }

  storage_data_disk {
    name              = "ghe-server-data-disk"
    create_option     = "Empty"
    lun               = 1
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 200
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  os_profile {
    computer_name  = "ghe-server"
    admin_username = "ghe-server-admin"
    admin_password = random_password.admin_password.result
  }

  depends_on = [
    module.vnet
  ]
}

resource "azurerm_storage_account" "github_actions_storage" {
  name                     = var.github_actions_storage_account_name
  location                 = azurerm_resource_group.github_enterprise_server.location
  resource_group_name      = azurerm_resource_group.github_enterprise_server.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  allow_blob_public_access = false

  network_rules {
    default_action = "Deny"
  }

  lifecycle {
    ignore_changes = [
      network_rules
    ]
  }
}

resource "azurerm_private_endpoint" "github_actions_storage" {
  name                = "github-actions-storage-pe"
  location            = azurerm_resource_group.github_enterprise_server.location
  resource_group_name = azurerm_resource_group.github_enterprise_server.name
  subnet_id           = module.vnet.vnet_subnets[1]

  private_service_connection {
    name                           = "github-actions-storage-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.github_actions_storage.id
    subresource_names = [
      "blob"
    ]
  }
}

resource "azurerm_storage_account_network_rules" "github_actions_storage_network_rules" {
  storage_account_id = azurerm_storage_account.github_actions_storage.id

  default_action = "Deny"
  bypass         = [
    "None"
  ]
  virtual_network_subnet_ids = module.vnet.vnet_subnets

  private_link_access {
    endpoint_resource_id = azurerm_private_endpoint.github_actions_storage.subnet_id
  }
}
