variable "resource_groups"{}
/*  type = map(object({
    location = string
  }))
}*/ 

/*
variable "rsg-name" {
}

variable "rsg-location" {
}
*/
/*resource "azurerm_resource_group" "rsg" {
  name = var.rsg-name
  location = var.rsg-location
  
}*/

variable "rsg-name" {
  type = string
}

variable "rsg-location" {
  type = string
}

resource "azurerm_resource_group" "rg" {
  name     = var.rsg-name
  location = var.rsg-location
}

output "name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}

/*
resource "azurerm_resource_group" "rsg" {
  for_each = var.resource_groups

  name = each.key
  location = each.value.location
}

output "name" {
  
}
*/