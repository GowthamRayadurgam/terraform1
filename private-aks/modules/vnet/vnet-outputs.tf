output "vnet-address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  value = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}

output "subnet_address_prefix" {
  value = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.address_prefixes }
}