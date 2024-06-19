resource "azurerm_public_ip" "app_GW-Public-IP" {
  name = "app_GW-Public-IP"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "static"
}


locals {
  backend_address_pool_name      = "${azurerm_application_gateway.app-GW.name}-beap"
  frontend_port_name             = "${azurerm_application_gateway.app-GW.name}-feport"
  frontend_ip_configuration_name = "${azurerm_application_gateway.app-GW.name}-feip"
  http_setting_name              = "${azurerm_application_gateway.app-GW.name}-be-htst"
  listener_name                  = "${azurerm_application_gateway.app-GW.name}-httplstn"
  request_routing_rule_name      = "${azurerm_application_gateway.app-GW.name}-rqrt"
  redirect_configuration_name    = "${azurerm_application_gateway.app-GW.name}-rdrcfg"
 }

resource "azurerm_application_gateway" "app-GW" {
  resource_group_name = var.resource_group_name
  location = var.location
  name = var.app_Gw_name

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }


  gateway_ip_configuration {
    name      = "${azurerm_application_gateway.app-GW.name}-gatewayip"
    subnet_id = var.gateway_ip_subnet_id
  }


  frontend_port {
    name = local.frontend_port_name
    port = 80
  }


  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_GW-Public-IP.id
  }


  backend_address_pool {
    name = local.backend_address_pool_name
  }


  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = var.backend_http_settings_port
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}