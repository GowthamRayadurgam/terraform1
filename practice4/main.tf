terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.78.0"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "rsg1" {
  source       = "./modules/ResourceGRP"
  rsg-name     = var.rsg-name
  rsg-location = var.rsg-location
}

module "storage" {
  source       = "./modules/storage"
  rsg-location = var.rsg-location
  rsg-name     = var.rsg-name
}

module "virtual-network" {
  source          = "./modules/vnet"
  vnet1           = var.vnet1
  rsg-location    = var.rsg-location
  rsg-name        = var.rsg-name
  CIDR1           = var.CIDR1
  subnet1-address = var.subnet1-address
}

module "users-creation" {
  source = "./modules/user"
  #  count  = length(var.users)  -- Count Parameter should not be used in root module
  users = {
  }
}

module "publicIP" {
  source       = "./modules/publicIP"
  rsg-name     = var.rsg-name
  rsg-location = var.rsg-location
}

module "nsg" {
  source       = "./modules/nsg"
  rsg-location = var.rsg-location
  rsg-name     = var.rsg-name
}

module "NIC" {
  source          = "./modules/NIC"
  rsg-name        = var.rsg-name
  rsg-location    = var.rsg-location
  subnet1-address = module.virtual-network.subnet1-address
}

#module "NIC_NSG" {
#  source = "./modules/NIC_NSG"
#}

module "RandomPassword" {
  source = "./modules/RandomPassword"
}

module "vm" {
  source       = "./modules/vm"
  rsg-name     = var.rsg-name
  rsg-location = var.rsg-location
  vmname       = var.vmname
  userpasswd   = module.RandomPassword.userpasswd
  nic = module.NIC.nic1
  Username = var.username
}

resource "azurerm_network_interface_security_group_association" "NIC-NSG" {
  network_interface_id = module.NIC.nic1
  network_security_group_id = module.nsg.nsg1
}


output "VM1-access" {
  value = nonsensitive(module.vm.Username)
#  sensitive = true
}
