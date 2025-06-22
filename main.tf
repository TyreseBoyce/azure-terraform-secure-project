locals {
  departments = ["hr", "it", "accounts", "finance", "marketing"]
  subnets = {
    for i, dept in local.departments :                                                          # This creates a subnet for each department
    "${terraform.workspace}-subnet-${dept}" => cidrsubnet(module.vnets.address_spaces[0], 8, i) # This calculates a unique subnet CIDR for each department
  }
}
resource "azurerm_resource_group" "main" {
  name     = "rg-${terraform.workspace}-core"
  location = var.location
}
module "vnets" {
  source               = "./modules/virtual-network-module"
  virtual_network_name = "${terraform.workspace}-vnet"
  resource_group_name  = "rg-${terraform.workspace}-core"
  address_spaces = {
    dev  = ["10.0.0.0/16"]
    prod = ["10.1.0.0/16"]
  }
  depends_on = [azurerm_resource_group.main] #This ensures the vnet is created only after the resource group.
}
module "subnets" {
  source               = "./modules/subnet-module"
  for_each             = local.subnets # This iterates over the subnets map to create a subnet for each department
  subnet_name          = each.key
  virtual_network_name = "${terraform.workspace}-vnet"
  resource_group_name  = "rg-${terraform.workspace}-core"
  address_prefix       = each.value
  depends_on           = [module.vnets]
}
