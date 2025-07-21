resource "azuread_user" "user" {
  user_principal_name = var.user_principal_name
  display_name        = var.display_name
  password            = var.password    
}