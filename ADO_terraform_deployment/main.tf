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
  source       = "./ResourceGRP"
  rsg-name     = var.rsg-name
  rsg-location = var.rsg-location
}

module "storage" {
  source       = "./storage"
  rsg-location = var.rsg-location
  rsg-name     = var.rsg-name
}

module "virtual-network" {
  source          = "./vnet"
  vnet1           = var.vnet1
  rsg-location    = var.rsg-location
  rsg-name        = var.rsg-name
  CIDR1           = var.CIDR1
  subnet1-address = var.subnet1-address
}