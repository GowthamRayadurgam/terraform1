terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.78.0"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

}

resource "azurerm_virtual_network" "VNET-1" {
  name                = "Terraform-Vnet"
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = var.address_space-1
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "Terraform-subnet-1"
  address_prefixes     = var.address_prefixes
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.VNET-1.name
}


resource "azurerm_storage_account" "backend-storage" {
  name                     = "terraformbackend1512"
  location                 = var.location
  resource_group_name      = var.resource_group
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend-container" {
  storage_account_name = azurerm_storage_account.backend-storage.name
  name                 = "terraform-backend-file-container"

}


module "public-ip-1" {
  source              = "./IP-module"
  location            = module.RSG.Rsg
  resource_group_name = module.RSG.Rsg-1
}

module "VNET2" {
  source              = "./VNET2-module"
  resource_group_name = var.resource_group
  location            = var.location
  address_space-2     = var.address_space-2
  address_prefixes-2  = var.address_prefixes-2
}

module "RSG" {
  source = "./RSG-Module"
  location = var.location
  resource_group_name = var.resource_group
}


moved {
  to = module.RSG.azurerm_resource_group.rsg-1
  from = azurerm_resource_group.rsg-1
}