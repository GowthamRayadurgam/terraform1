output "public_IP_of_VM" {
  value = azurerm_public_ip.public_ip.ip_address
}