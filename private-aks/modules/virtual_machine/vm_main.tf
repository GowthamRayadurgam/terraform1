resource "azurerm_public_ip" "public_ip" {
  name = "${var.vm_name}Publicip"
  resource_group_name         = "private_aks_rsg"
  location = var.location
  allocation_method = "Static"
  domain_name_label = lower("${var.vm_name}domain")
}

resource "azurerm_network_security_group" "nsg" {
  location = var.location
  resource_group_name         = "private_aks_rsg"
  name = "${var.vm_name}nsg"
}

resource "azurerm_network_security_rule" "example" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "private_aks_rsg"
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_interface" "nic" {
  name = var.nic_name
  location = var.location
  resource_group_name = "private_aks_rsg"
  ip_configuration {
    name = "IP-configuration"
    subnet_id = var.subnet_id
    private_ip_address_version = "IPv4"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = try(azurerm_public_ip.public_ip.id, null)
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [ azurerm_network_interface.nic, azurerm_network_security_group.nsg ]
}

resource "azurerm_linux_virtual_machine" "Virtual_machine" {
  resource_group_name = "private_aks_rsg"
  location = var.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size = var.vm_size
  name = var.vm_name
  admin_username = "gowtham"
  admin_password = "Gowtham@123"
  disable_password_authentication = false
  os_disk {
    name = "${var.vm_name}Osdisk"
    caching = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.vm_os_disk_image, "publisher", null)
    sku = lookup(var.vm_os_disk_image, "sku", null)
    version = lookup(var.vm_os_disk_image, "version", null)
    offer = lookup(var.vm_os_disk_image, "offer", null)
  }
  
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"

    connection {
      type     = "ssh"
      user     = "gowtham"
      password = "Gowtham@123"
      host     = azurerm_public_ip.public_ip.ip_address
    }
  }


/*  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
     ]  
    connection {
      type     = "ssh"
      user     = "gowtham"
      password = "Gowtham@123"
      host     = azurerm_public_ip.public_ip.ip_address
    }  
  }  */



  depends_on = [ azurerm_network_interface.nic, azurerm_network_security_group.nsg ]


}