locals {
  departments = ["hr", "it", "accounts", "finance", "marketing"]
  subnets = {
    for i, dept in local.departments :                                                          # This creates a subnet for each department
    "${terraform.workspace}-subnet-${dept}" => cidrsubnet(module.vnets.address_spaces[0], 8, i) # This calculates a unique subnet CIDR for each department
  }
  it_hr_nsg = ["it", "hr"] # Departments that are allowed RDP access
  zero_trust_nsg = ["accounts", "finance", "marketing"]
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
  depends_on = [azurerm_resource_group.main] #This ensures the vnet is created only after the resource group.
}
module "subnets" {
  source               = "./modules/subnet-module"
  for_each             = local.subnets # This iterates over the subnets map to create a subnet for each department
  subnet_name          = each.key
  virtual_network_name = "${terraform.workspace}-vnet"
  resource_group_name  = azurerm_resource_group.main.name
  address_prefix       = each.value
  depends_on           = [module.vnets]
}

# resource "azurerm_network_security_group" "nsg" {
#   for_each            = local.subnets
#   name                = "${each.key}-nsg"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }

# resource "azurerm_network_security_rule" "nsg_rule" {
#     for_each            = local.subnets
#     name                       = "AllowHTTPS"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   resource_group_name         = azurerm_resource_group.main.name
#   network_security_group_name = azurerm_network_security_group.nsg[each.key].name
# }
# resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
#   for_each                  = module.subnets
#   subnet_id                 = each.value.id
#   network_security_group_id = azurerm_network_security_group.nsg[each.key].id
# }

resource "azurerm_network_security_group" "nsg_it" {
  name                = "it_hr-NSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
resource "azurerm_subnet_network_security_group_association" "it_assoc" {
  for_each = {
     for dept in local.it_hr_nsg :
    dept => module.subnets["${terraform.workspace}-subnet-${dept}"].id
  }
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg_it.id
}


resource "azurerm_network_security_group" "nsg_zero_trust" {
  name                = "ZeroTrust-NSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "zero_trust_assoc" {
  for_each = {
     for dept in local.zero_trust_nsg :
    dept => module.subnets["${terraform.workspace}-subnet-${dept}"].id
  }
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg_zero_trust.id
}