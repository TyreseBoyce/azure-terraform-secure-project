variable "nsg_name"{
    type = string
    description = "The name of the network security group being created"

}
variable "location"{
    type = string
    description = "The location of the resource being created"
    default = "eastus"

}
variable "resource_group_name"{
    type = string
    description = "The name of the resource group the NSG is being created in"
}
variable "subnet_id" {
    type = string
    description = "The ID of the subnet to associate with the NSG"
}
variable "rules" {
    type = map(object({
        priority                    = number
        direction                   = string
        access                      = string
        protocol                    = string
        source_port_range           = string
        destination_port_range      = string
        source_address_prefix       = string
        destination_address_prefix  = string
    }))
    description = "A map of network security rules to apply to the NSG"
    default     = {}
}
variable "network_security_group_id" {
    type = string
    description = "The ID of the network security group to associate with the subnet"
    default     = ""
}