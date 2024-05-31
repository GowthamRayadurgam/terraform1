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



module "rsg" {
  source = "./modules/ResourceGRP"
  resource_groups = var.resource_groups
  for_each = var.resource_groups

  name     = each.key
  location = each.value.location
}

locals {
  flattened_virtual_networks = {
    for rg_key, vnets in var.virtual_networks : rg_key => {
      for vnet_key, vnet in vnets : "${rg_key}-${vnet_key}" => {
        name                = vnet_key
        location            = module.rsg[rg_key].location
        resource_group_name = module.rsg[rg_key].name
        address_space       = vnet.address_space
        subnets             = vnet.subnets
      }
    }
  }
  merged_virtual_networks = merge([for k, v in local.flattened_virtual_networks : v]...)
}

module "virtual_networks" {
  source = "./modules/vnet"

  for_each = local.merged_virtual_networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  subnets             = each.value.subnets
}

output "Vnet-name" {
  value = module.virtual_networks
}

output "rsg-name" {
  value = module.rsg
}



/*module "virtual_networks" {
  source = "./modules/vnet"
  for_each = flatten([
    for rg_key, vnets in var.virtual_networks : [
      for vnet_key, vnet in vnets : {  
        name                = vnet_key
        location            = module.rsg[rg_key].location
        resource_group_name = module.rsg[rg_key].name
        address_space       = vnet.address_space
        subnets             = vnet.subnets
      }
    ]
  ])

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  subnets             = each.value.subnets
} */

/*
module "rsg" {
  source       = "./modules/ResourceGRP"
  resource_groups = var.resource_groups
#  rsg-name     = var.rsg-name
#  rsg-location = var.rsg-location
}
*/

/*
module "vnet" {
  source = "./modules/vnet"
  virtual_networks = var.virtual_networks
}
*/

/*module "storage" {
  source       = "./modules/storage"
  rsg-location = var.rsg-location
  rsg-name     = var.rsg-name
} */

/*
module "virtual-network" {
  source          = "./modules/vnet"
  vnet1           = var.vnet1
  rsg-location    = var.rsg-location
  rsg-name        = var.rsg-name
  CIDR1           = var.CIDR1
  subnet1-address = var.subnet1-address
}

/*module "users-creation" {
  source = "./modules/user"
  #  count  = length(var.users)  -- Count Parameter should not be used in root module
  users = {
  }
}*/

/*
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
  nic          = module.NIC.nic1
  Username     = var.username
}

module "privatelb" {
  source            = "./modules/pri-lb"
  frontend-port     = var.frontend-port
  backend-port      = var.backend-port
  nat-backend-port  = var.backend-port
  nat-frontend-port = var.frontend-port
  rsg-name          = var.rsg-name
  rsg-location      = var.rsg-location
  #  subnet1-address   = var.subnet1-address
}



resource "azurerm_network_interface_security_group_association" "NIC-NSG" {
  network_interface_id      = module.NIC.nic1
  network_security_group_id = module.nsg.nsg1
}



output "VM1-access" {
  value = nonsensitive(module.vm.Username)
  #  sensitive = true
}

*/