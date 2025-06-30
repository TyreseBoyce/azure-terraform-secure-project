variable "location" {
  type        = string
  description = "The location of the resourse being created"
  default     = "eastus"
}
variable "subnet_rules" {
  type = map(object({
    nsg_name = string
    rules = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}
