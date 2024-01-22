resource "azuread_user" "Azure-AD-users" {
#  count  = length(var.users)
  for_each = var.users
  user_principal_name = var.users[each.key]
  display_name = var.users[each.value]
  password = random_password.password[each.key].result
}


resource "random_password" "password" {
  length = 12
  special = true
}