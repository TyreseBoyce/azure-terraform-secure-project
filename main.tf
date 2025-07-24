locals {
  vm_departments = [
    "${terraform.workspace}-subnet-it",
    "${terraform.workspace}-subnet-hr"
  ]
  departments = ["hr", "it", "accounts", "finance", "marketing"]
  subnets = {
    for i, dept in local.departments :                                                          # Creates a subnet for each department
    "${terraform.workspace}-subnet-${dept}" => cidrsubnet(module.vnets.address_spaces[0], 8, i) # Calculates a unique subnet CIDR for each department
  }
}
resource "azurerm_resource_group" "main" {
  name     = "rg-${terraform.workspace}-core"
  location = var.location
}
module "vnets" {
  source               = "./modules/virtual-network-module"
  virtual_network_name = "${terraform.workspace}-vnet"
  resource_group_name  = azurerm_resource_group.main.name
  address_spaces = {
    dev  = ["10.0.0.0/16"]
    prod = ["10.1.0.0/16"]
  }
  depends_on = [azurerm_resource_group.main] # Ensures the vnet is created only after the resource group.
}
module "subnets" {
  source               = "./modules/subnet-module"
  for_each             = local.subnets # Iterates over the subnets map to create a subnet for each department
  subnet_name          = each.key
  virtual_network_name = "${terraform.workspace}-vnet"
  resource_group_name  = azurerm_resource_group.main.name
  address_prefix       = each.value
  depends_on           = [module.vnets]
}
module "nsgs" {
  for_each = var.subnet_rules

  source              = "./modules/nsg-module"
  nsg_name            = "${terraform.workspace}-${each.value.nsg_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.subnets["${terraform.workspace}-subnet-${each.key}"].id
  rules               = each.value.rules
}
module "virtual_machine" {
  source               = "./modules/virtual-machine-module"
  for_each             = toset(local.vm_departments) # Creates a VM for each department in the vm_departments list
  virtual_machine_name = "${each.key}-vm"
  admin_password       = var.admin_password
  admin_username       = var.admin_username
  computer_name        = var.computer_name
  size                 = var.size
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  nic                  = "${each.key}-nic"
  subnet_id            = module.subnets[each.key].id
  depends_on           = [module.nsgs]
}
# module "users" {
#   source              = "./modules/user-module"
#   for_each            = var.users
#   user_principal_name = each.value.user_principal_name
#   display_name        = each.value.display_name
#   password            = each.value.password
# }