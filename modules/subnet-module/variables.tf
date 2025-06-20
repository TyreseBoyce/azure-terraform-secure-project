variable "location"{
    type = string
    description = "The location of the resourse being created"
    default = "eastus"

}
variable "virtual_network_name"{
    type = string
    description = "The name of the subnet being created"

}
variable "address_prefix"{
    type = string
    description = "The address space of the subnetk being created"
}
variable "resource_group_name"{
    type = string
    description = ""
}
variable "subnet_name"{
    type = string
}