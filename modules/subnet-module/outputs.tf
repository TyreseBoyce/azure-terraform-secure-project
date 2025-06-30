output "id" {
  value = azurerm_subnet.subnets.id
}
# output "subnet_ids" {
#   value = {
#     for name, subnet in azurerm_subnet.subnets :
#     name => azurerm_subnet.subnets.id
#   }
# }