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
variable "admin_username" {
  type        = string
  description = "The admin username for the virtual machine"
}
variable "admin_password" {
  type        = string
  description = "The admin password for the virtual machine"
  sensitive   = true
}
variable "computer_name" {
  type        = string
  description = "The computer name for the virtual machine"
}
variable "size" {
  type        = string
  description = "The size of the virtual machine"
  default     = "Standard_B1s" // Default VM size 
}
variable "users" {
  type = map(object({
    user_principal_name = string
    display_name        = string
    password            = string
  }))
  sensitive = true
  description = "Map of users to be created with their principal name, display name, and password"
}
