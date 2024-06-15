resource "azurerm_virtual_network_peering" "peering" {
    resource_group_name = var.resource_group_name
    name = var.peer_1_2
    virtual_network_name = var.vnet_1_name
    remote_virtual_network_id = var.vnet_2_id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "peer_back" {
  name = var.peer_2_1
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_2_name
  remote_virtual_network_id = var.vnet_1_id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true
}