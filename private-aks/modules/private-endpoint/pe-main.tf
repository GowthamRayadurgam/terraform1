resource "azurerm_private_dns_zone" "pvt_dns_zone" {
  name = var.pvt_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pvt_dns_vnet_link" {
  name = var.pvt_dns_vnet_link_name
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pvt_dns_zone.name
  virtual_network_id = var.pvt_dns_vnet_id
  registration_enabled = true
}

resource "azurerm_private_endpoint" "pe" {
    name = var.pe_name
    location = var.location
    resource_group_name = var.resource_group_name
    subnet_id = var.pe_subnet_id

    private_service_connection {
      name = "${var.pe_name}-service_connection"
      private_connection_resource_id = var.private_connection_resource_id
      is_manual_connection = false
    }

    private_dns_zone_group {
      name = "${var.pvt_dns_zone_name}-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.pvt_dns_zone.id]
    }
}