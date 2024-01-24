variable "rsg-location" { 
}

variable "rsg-name" { 
}

#variable "subnet1-address" {
#}

variable "frontend-port" {
  
}

variable "backend-port" {
  
}


variable "nat-backend-port" {
  
}

variable "nat-frontend-port" {
  
}


resource "azurerm_lb" "Private-lb" {
  name = "Private-lb"
  location = var.rsg-location
  resource_group_name = var.rsg-name
  sku = "Standard"

  frontend_ip_configuration {
    name = "lb-frontend"
  #  subnet_id = var.subnet1-address.id
    private_ip_address_allocation = "Static"
    private_ip_address_version = "IPv4"
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend" {
  name = "lb-backend"
  loadbalancer_id = azurerm_lb.Private-lb.id
}

resource "azurerm_lb_backend_address_pool_address" "lb-backend-address" {
  name = "lb-backend-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
}
resource "azurerm_lb_nat_rule" "name" {
  resource_group_name            = var.rsg-name
  loadbalancer_id                = azurerm_lb.Private-lb.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = var.nat-frontend-port
  backend_port                   = var.nat-backend-port
  frontend_ip_configuration_name = "lb-frontend"
}


resource "azurerm_lb_rule" "lb-rule" {
  name = "lb-rule"
  loadbalancer_id = azurerm_lb.Private-lb.id
  protocol = "Tcp"
  frontend_port = var.frontend-port
  backend_port = var.backend-port
  frontend_ip_configuration_name = "lb-frontend"
}



output "lb-id" {
  value = azurerm_lb.Private-lb.id 
}

output "frontend-ip" {
  value = azurerm_lb.Private-lb.frontend_ip_configuration
}

output "private-ip" {
  value = azurerm_lb.Private-lb.private_ip_addresses
}

