resource "azurerm_public_ip" "app_GW-Public-IP" {
  name = "app_GW-Public-IP"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
}


locals {
  backend_address_pool_name      = "${var.app_Gw_name}-beap"
  frontend_port_name             = "${var.app_Gw_name}-feport"
  frontend_ip_configuration_name = "${var.app_Gw_name}-feip"
  http_setting_name              = "${var.app_Gw_name}-be-htst"
  listener_name                  = "${var.app_Gw_name}-httplstn"
  request_routing_rule_name      = "${var.app_Gw_name}-rqrt"
  redirect_configuration_name    = "${var.app_Gw_name}-rdrcfg"
 }

resource "azurerm_application_gateway" "app-GW" {
  resource_group_name = var.resource_group_name
  location = var.location
  name = var.app_Gw_name

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }


  gateway_ip_configuration {
    name      = "${var.app_Gw_name}-gatewayip"
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
/*
  trusted_root_certificate {
    name = var.cert_name
    key_vault_secret_id = var.cert_secret_id
  }
}



/*
resource "azurerm_network_interface" "app_GW_nic" {
  name = "${azurerm_application_gateway.app-GW.name}-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "${azurerm_application_gateway.app-GW.name}-nic-ip-config"
    subnet_id = var.app_GW_nic
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "app_GW_nic_association" {
  network_interface_id = azurerm_network_interface.app_GW_nic.id
  ip_configuration_name = azurerm_network_interface.app_GW_nic.ip_configuration[0].name
  backend_address_pool_id = tolist(azurerm_application_gateway.app-GW.backend_address_pool).0.id
}
*/