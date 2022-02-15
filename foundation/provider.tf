# This is a placehold to allow terraform validate to run

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias = "identity"
  features {}
}
provider "azurerm" {
  alias = "management"
  features {}
}
provider "azurerm" {
  alias = "connectivity"
  features {}
}
