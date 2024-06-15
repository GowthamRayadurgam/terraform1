output "resource_group_name" {
  value = azurerm_resource_group.Private-Aks.name
}

output "location" {
  value = azurerm_resource_group.Private-Aks.location
}

output "public_IP_of_VM" {
  value = module.Virtual_machine.public_IP_of_VM
}