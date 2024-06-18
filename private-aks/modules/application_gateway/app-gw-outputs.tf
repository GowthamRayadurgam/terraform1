output "app_gw_id" {
  value = azurerm_application_gateway.app-GW.id
}

output "app_Gw_public_ip" {
  value = azurerm_public_ip.app_GW-Public-IP.ip_address
}