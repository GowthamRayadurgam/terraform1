resource "azurerm_virtual_machine" "terraformVM" {
  name = var.vmname
  resource_group_name = var.rsg-name
  location = var.rsg-location
  vm_size =  "standard_F2"
  network_interface_ids = [var.nic]

  storage_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts-gen2"
    version = "latest"
  }

  storage_os_disk{
    create_option = "FromImage"
    name = "myosDisk"
    caching = "ReadWrite"
    managed_disk_type  = "Standard_LRS"
  }

  os_profile {
    computer_name = "Gowtham"
    admin_password = var.userpasswd
    admin_username = var.Username
  }
}

output "Username" {
  value = azurerm_virtual_machine.terraformVM.os_profile
}
