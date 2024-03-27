variable "rsg-location" { 
}

variable "rsg-name" { 
}

variable "subscription_id" {
}

variable "frontend-ip" {
}

variable "subnet1-address" {
}



resource "azurerm_private_link_service" "private-link"{
    name = "Private-Link"
    resource_group_name = var.rsg-name
    location = var.rsg-location
    auto_approval_subscription_ids = ["var.subscription_id"]
    load_balancer_frontend_ip_configuration_ids = [var.frontend-ip.id]
    nat_ip_configuration {
      name = "primary"
      subnet_id = var.subnet1-address.id
      primary = true
    }
}


resource "azurerm_private_endpoint" "private-endpoint" {
  name = "private-endpoint"
  resource_group_name = var.rsg-name
  location = var.rsg-location
  subnet_id = var.
}