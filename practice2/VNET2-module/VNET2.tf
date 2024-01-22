resource "azurerm_virtual_network" "VNET2-Terraform" {
  name = "VNET2-Terraform"
  location = var.location
  resource_group_name = var.resource_group_name
  address_space = var.address_space-2
}

resource "azurerm_subnet" "subnet2-terraform" {
  name = "Subnet2-Terraform"
  address_prefixes = var.address_prefixes-2
  virtual_network_name = azurerm_virtual_network.VNET2-Terraform.name
  resource_group_name = var.resource_group_name
}