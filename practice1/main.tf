terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "967c511b-f9af-42e1-ac78-71eb62373990"
  client_id       = "f937e941-4c5e-4d99-9b36-339389b5bcbc"
  client_secret   = "1AF8Q~JM6hCRlER2GYhccUmRpmyA_LfBs1~J.dg3"
  tenant_id       = "d0ddd56b-09d9-410d-afb6-de5baf79d4b4"
}

# Resource Group
resource "azurerm_resource_group" "terra_RSG" {
  name     = "terraform_RSG"
  location = "West Europe"
}

# Public IP
resource "azurerm_public_ip" "terra_IP" {
  name                = "Terraform_IP"
  location            = azurerm_resource_group.terra_RSG.location
  resource_group_name = azurerm_resource_group.terra_RSG.name
  allocation_method   = "Dynamic"
}

# NSG
resource "azurerm_network_security_group" "terra_NSG" {
  name                = "terraform_NSG"
  location            = azurerm_resource_group.terra_RSG.location
  resource_group_name = azurerm_resource_group.terra_RSG.name
  security_rule {
    name                       = "rule1"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VNET
resource "azurerm_virtual_network" "terra_VNET" {
  name                = "terraform_VNET"
  resource_group_name = azurerm_resource_group.terra_RSG.name
  location            = azurerm_resource_group.terra_RSG.location
  address_space       = ["10.2.0.0/16"]
}

# Subnet - 1
resource "azurerm_subnet" "terra_subnet_a" {
  name                 = "Terraform_subnet_a"
  address_prefixes     = ["10.2.4.0/24"]
  virtual_network_name = azurerm_virtual_network.terra_VNET.name
  resource_group_name  = azurerm_resource_group.terra_RSG.name
}

#Subnet - 2
resource "azurerm_subnet" "terra_subnet_b" {
  name                 = "Terraform_subnet_b"
  address_prefixes     = ["10.2.5.0/24"]
  virtual_network_name = azurerm_virtual_network.terra_VNET.name
  resource_group_name  = azurerm_resource_group.terra_RSG.name
}

# NSG and Subnet association - 1
resource "azurerm_subnet_network_security_group_association" "terra_ASSO1" {
  subnet_id                 = azurerm_subnet.terra_subnet_a.id
  network_security_group_id = azurerm_network_security_group.terra_NSG.id
}

# NSG and Subnet association - 2
resource "azurerm_subnet_network_security_group_association" "terra_ASSO2" {
  subnet_id                 = azurerm_subnet.terra_subnet_b.id
  network_security_group_id = azurerm_network_security_group.terra_NSG.id
}

# NIC card
resource "azurerm_network_interface" "terra_NIC" {
  name                = "Terraform_NAT"
  location            = azurerm_resource_group.terra_RSG.location
  resource_group_name = azurerm_resource_group.terra_RSG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terra_subnet_a.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux machine
resource "azurerm_linux_virtual_machine" "terra-LVM" {
  name                  = "Terraform_LVM"
  resource_group_name   = azurerm_resource_group.terra_RSG.name
  location              = azurerm_resource_group.terra_RSG.location
  size                  = "Standard_B1s"
  admin_username        = "Gowtham"
  network_interface_ids = [azurerm_network_interface.terra_NIC.id]
  computer_name         = "LinuxMachine-Terraform"
  admin_ssh_key {
    username   = "Gowtham"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
#resource "azurerm_subnet_network_security_group_association" "terra_NSG_Associate" {
#  subnet_id = azurerm_subnet.name
#}
