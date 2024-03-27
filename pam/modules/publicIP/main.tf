resource "azurerm_public_ip" "PIP" {
    name = "PIP"
    resource_group_name = var.rsg-name
    location = var.rsg-location
    sku = "Basic"
    allocation_method = "Dynamic"

    tags = {
      "purpose" = "test"
    }
  
}