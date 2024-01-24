variable "rsg-name" { 
}

variable "rsg-location" {
}



resource "azurerm_network_security_group" "nsg1" {
  resource_group_name = var.rsg-name
  name = "nsg1"
  location = var.rsg-location
  
  security_rule{
    name = "rule-1"
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  tags = {
    purpose = "test"
  }
}


output "nsg1" {
  value = azurerm_network_security_group.nsg1.id
}
