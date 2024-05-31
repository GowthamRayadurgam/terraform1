variable "vnet1" {
}

variable "rsg-location" {
}

variable "rsg-name" {
}

variable "CIDR1" {
}

variable "subnet1-address" {
}


resource "azurerm_virtual_network" "VNET1" {
  name = var.vnet1
  location = var.rsg-location
  resource_group_name = var.rsg-name
  address_space =[var.CIDR1]
}
 
resource "azurerm_subnet" "subnet1" {
    virtual_network_name = var.vnet1
    address_prefixes = [var.subnet1-address]
    name = "default"
    resource_group_name = var.rsg-name
    private_endpoint_network_policies_enabled = true
}


output "subnet1-address" {
  value = azurerm_subnet.subnet1
}

output "vnet1" {
  value = azurerm_virtual_network.VNET1
  
}