variable "rsg-name" {
}

variable "rsg-location" {
}


resource "azurerm_resource_group" "rsg1" {
  name = var.rsg-name
  location = var.rsg-location
  
}