resource "azurerm_network_interface_security_group_association" "Association" {
  network_interface_id = "azurerm_network_interface.module.NIC.nic1"
  network_security_group_id = "azurerm_network_security_group.module.nsg.nsg1"
}