resource "azurerm_resource_group" "Private-Aks" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "Gowtham-terraform" {
  display_name = "Gowtham-terraform"
}

data "azuread_service_principal" "terraform_app_id" {
  client_id = "107ea390-d996-40b7-a339-72dd4c714ba5"
}

data "azuread_service_principal" "terraform_obj_id" {
  object_id = "46299ca2-6590-4222-a859-4e20082e494f"
}

module "Hub_vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.Hub_vnet_name
  address_space       = var.hub_address_space
  subnets = [{
    name                                          = "Firewall_Subnet"
    address_prefixes                              = var.FW_address_prefix
    private_endpoint_network_policies_enabled     = true
    private_link_service_network_policies_enabled = true
    },
    {
      name                                          = "application_gateway_Subnet_nic"
      address_prefixes                              = var.app_GW_nic_prefix
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    {
      name                                          = "azure-bastion-subnet"
      address_prefixes                              = var.bastion_subnet
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
  },
  {
    name = "application_gateway_backend"
    address_prefixes = var.app_GW_backend_prefix
    private_endpoint_network_policies_enabled = true
    private_link_service_network_policies_enabled = true
  }
  ]

  depends_on = [azurerm_resource_group.Private-Aks]
}

module "spoke_Vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  vnet_name           = var.spoke_vnet_name
  location            = var.location
  address_space       = var.spoke_address_space
  subnets = [{
    name : "node_pool"
    address_prefixes : var.nodepool_prefix
    private_endpoint_network_policies_enabled : true
    private_link_service_network_policies_enabled : true
    },
    {
      name : "vm_subnet"
      address_prefixes : var.vmsubnet_prefix
      private_endpoint_network_policies_enabled : true
      private_link_service_network_policies_enabled : true
    }
  ]
  depends_on = [azurerm_resource_group.Private-Aks]
}

module "vnet-peering" {
  source              = "./modules/vnet_peering"
  vnet_1_name         = var.Hub_vnet_name
  vnet_1_id           = module.Hub_vnet.vnet_id
  vnet_2_id           = module.spoke_Vnet.vnet_id
  vnet_2_name         = var.spoke_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  peer_1_2            = "${var.Hub_vnet_name}To${var.spoke_vnet_name}"
  peer_2_1            = "${var.spoke_vnet_name}To${var.Hub_vnet_name}"
}

module "Virtual_machine" {
  source                        = "./modules/virtual_machine"
  vm_name                       = var.vm_name
  location                      = var.location
  resource_group_name           = var.location
  nic_name                      = var.nic_name
  vm_size                       = var.vm_size
  vm_os_disk_image              = var.vm_os_disk_image
  subnet_id                     = module.spoke_Vnet.subnet_id[var.vm_subnet]
  private_ip_address_allocation = "Dynamic"
  depends_on                    = [azurerm_resource_group.Private-Aks]
}



module "acr" {
  source              = "./modules/acr"
  acr_name            = "acr1512"
  acr_sku             = "Basic"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "aks" {
  source                            = "./modules/aks"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  aks_name                          = var.aks_name
  aks_version                       = "1.28.9"
  aks_dns_prefix                    = var.aks_name
  aks_azure_policy_enabled          = true
  default_node_pool_max_count       = "2"
  default_node_pool_node_count      = "1"
  default_node_pool_os_disk_size_gb = "128"
  default_node_pool_os_disk_type    = "Managed"
  default_node_pool_os_sku          = "Ubuntu"
  default_nodepool_vm_size          = "Standard_D2_v2"
  default_node_pool_vnet_subnet_id  = module.spoke_Vnet.subnet_id["node_pool"]
  aks_dns_service_ip                = "10.3.0.5"
  aks_network_plugin                = "azure"
  aks_network_policy                = "calico"
  aks_service_cidr                  = "10.3.0.0/24"
  aks_outbound_type                 = "userDefinedRouting"
  gateway_id = module.app_GW.app_gw_id
  default_node_pool_min_count = "1"
    depends_on                        = [module.acr , module.app_GW]
}

resource "azurerm_role_assignment" "acr_aks" {
  principal_id                     = module.aks.aks_identity
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true
  depends_on = [ module.acr , module.aks ]
}

resource "azurerm_role_assignment" "agic_role" {
  principal_id = module.aks.ingress_application_gateway_identity
  role_definition_name = "Network Contributor"
  scope = module.app_GW.gateway_ip_configuration
  depends_on = [ module.aks , module.app_GW ]
}

resource "azurerm_role_assignment" "agic_GW_role" {
  principal_id = module.aks.ingress_application_gateway_identity
  role_definition_name = "Contributor"
  scope = module.app_GW.app_gw_id
  depends_on = [ module.aks , module.app_GW ]
}

module "app_GW" {
  source = "./modules/application_gateway"
  resource_group_name = var.resource_group_name
  location = var.location
  app_Gw_name = "agic"
  backend_http_settings_port = "80"
  gateway_ip_subnet_id = module.Hub_vnet.subnet_id["application_gateway_backend"]
  app_GW_nic = module.Hub_vnet.subnet_id["application_gateway_Subnet_nic"]
#  cert_name = var.appgw_cert_name
#  cert_secret_id = module.appgw_kv.cert_secret_id
}

module "ms_sql" {
  source = "./modules/sql"
  resource_group_name = var.resource_group_name
  location = var.location
  mssql_name = "mssql-server15121996"
  administrator_login_password = var.administrator_login_password
}

module "sql-pe" {
  source = "./modules/private-endpoint"
  location = var.location
  resource_group_name = var.resource_group_name
  private_connection_resource_id = module.ms_sql.mssql_server_id
  pe_subnet_id = module.spoke_Vnet.subnet_id["node_pool"]
  pvt_dns_vnet_id = module.spoke_Vnet.vnet_id
  pe_name = "sql-pe"
}

/*

module "appgw_kv" {
  source = "./modules/keyvault"
  location = var.location
  resource_group_name = var.resource_group_name
  terraform_app_id = data.azuread_service_principal.terraform_app_id
  terraform_obj_id = data.azuread_service_principal.terraform_obj_id
  kv_name = var.appgw_kv_name
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  certificate_passwd = var.appgw_certificate_passwd
  certificate_path = var.appgw_certificate_path
  cert_name = var.appgw_cert_name

}
*/

