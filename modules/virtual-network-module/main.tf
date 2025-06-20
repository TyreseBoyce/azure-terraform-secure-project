locals {
  address_spaces = lookup(var.address_spaces, terraform.workspace, ["10.99.0.0/16"])
}
resource "azurerm_virtual_network" "vnet" {
  name                =  var.vnet_name
  location            =  var.location
  resource_group_name = var.resource_group_name
  address_space       = local.address_spaces
}
