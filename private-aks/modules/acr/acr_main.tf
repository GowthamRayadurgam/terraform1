resource "azurerm_container_registry" "acr" {
  resource_group_name = var.resource_group_name
  location = var.location
  name = var.acr_name
  sku = var.acr_sku
}

