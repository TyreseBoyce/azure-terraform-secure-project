variable "location"{
    type = string
    description = "The location of the resourse being created"
    default = "eastus"

}
variable "vnet_name"{
    type = string
    description = "The name of the vnet being created"

}
variable "address_spaces"{
    type = map(list(string))
    description = "The address space of the virtual network being created"
}
variable "resource_group_name"{
    type = string
    description = ""

}