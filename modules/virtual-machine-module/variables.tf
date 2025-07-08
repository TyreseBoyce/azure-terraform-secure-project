variable "resource_group_name"{
    type = string
    description = "The name of the resource group the VM is being created in"
}
variable "location"{
    type = string
    description = "The location of the resource being created"
    default = "eastus"

}
variable "subnet_id" {
    type = string
    description = "The ID of the subnet to associate with the VM"
}
variable "nic" {
    type = string
    description = "The name of the network interface being created"
  //  default = "my-nic" // Default name for the NIC
}
variable "virtual_machine_name" {
    type = string
    description = "The name of the virtual machine being created"
  //  default = "my-vm" // Default name for the VM
}
variable "network_interface_ids"{
    type = list(string)
    description = "The list of network interface IDs to associate with the VM"
    default = []
}
variable "admin_username" {
    type = string
    description = "The admin username for the virtual machine"
}
variable "admin_password" {
    type = string
    description = "The admin password for the virtual machine"
    sensitive = true
}
variable "computer_name" {
    type = string
    description = "The computer name for the virtual machine"
}
variable "size" {
    type = string
    description = "The size of the virtual machine"
    default = "Standard_B1s" // Default VM size 
}