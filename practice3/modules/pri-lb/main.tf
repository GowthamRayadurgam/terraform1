resource "azurerm_lb" "lb" {
  name = "lb"
  location = var.location
  resource_group_name = var.rsgname
  sku = "Standard"

  frontend_ip_configuration {
    name = "lb-frontend"
    subnet_id = var.subnet1-address
    private_ip_address_allocation = "Static"
    private_ip_address_version = "IPv4"
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend" {
  name = "lb-backend"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "lb-backend-address" {
  name = "lb-backend-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id
  virtual_network_id = var.vnet1
}
resource "azurerm_lb_nat_rule" "name" {
  
}

resource "azurerm_lb" "name" {
  
}

resource "azurerm_lb_rule" "lb-rule" {
  name = "lb-rule"
  loadbalancer_id = azurerm_lb.lb.id
  protocol = "Tcp"
  frontend_port = var.frontend-port
  backend_port = var.backend-port
  frontend_ip_configuration_name = "lb-frontend"
}



output "lb-id" {
  value = azurerm_lb.lb.id 
}

output "frontend-ip" {
  value = azurerm_lb.lb.frontend_ip_configuration.private_ip_address
}

output "private-ip" {
  value = azurerm_lb.lb.private_ip_addresses
}

