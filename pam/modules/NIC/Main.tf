#########  Variables  ##############

variable "rsg-name" {
}

variable "rsg-location" {
  
}

variable "subnet1-address" {

}

############  Main configuration  ###################
resource "azurerm_network_interface" "nic1" {
  name = "nic1"
  resource_group_name = var.rsg-name
  location = var.rsg-location
  ip_configuration {
    name = "internal"
    subnet_id = var.subnet1-address.id
    private_ip_address_allocation = "Dynamic"
  }
}

#################   Outputs  #########################

output "nic1" {
  value = azurerm_network_interface.nic1.id
}