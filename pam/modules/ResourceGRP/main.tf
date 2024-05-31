variable "rsg" {
  type = map(string)
}

resource "azurerm_resource_group" "rsg" {
  for_each = var.rsg
  name = each.key
  location = each.value
  
}