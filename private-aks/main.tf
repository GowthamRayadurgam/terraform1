resource "azurerm_resource_group" "Private-Aks" {
  name     = var.resource_group_name
  location = var.location
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
      name                                          = "application_gateway_Subnet"
      address_prefixes                              = var.app_GW_prefix
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    {
      name                                          = "azure-bastion-subnet"
      address_prefixes                              = var.bastion_subnet
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
  }]

  depends_on = [ azurerm_resource_group.Private-Aks ]
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
  depends_on = [ azurerm_resource_group.Private-Aks ]
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
  depends_on = [ azurerm_resource_group.Private-Aks ]
}

