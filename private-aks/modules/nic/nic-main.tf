/*resource "azurerm_network_interface" "name" {
  name = var.nic_name
  location = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "IP-configuration"
    subnet_id = var.subnet_id
    private_ip_address_version = "IPv4"
    private_ip_address_allocation = var.private_ip_address_allocation
  }
} */