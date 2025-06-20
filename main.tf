locals {
  environment = terraform.workspace
}
resource "azurerm_resource_group" "main" {
  name     = "rg-${terraform.workspace}-core"
  location = var.location
}
module "vnet" {
  source              = "./modules/virtual-network-module"
  vnet_name           = "${terraform.workspace}-vnet"
  resource_group_name = "rg-${terraform.workspace}-core"
  address_spaces = {
    dev  = ["10.0.0.0/16"]
    prod = ["10.1.0.0/16"]
  }
  depends_on = [azurerm_resource_group.main] #This ensures the vnet is created only after the resource group.
}
