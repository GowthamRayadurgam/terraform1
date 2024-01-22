resource "azurerm_public_ip" "terraformIP" {
  name = "terraformIP"
  location = var.location
  allocation_method = "Dynamic"
  resource_group_name = var.resource_group_name
}

