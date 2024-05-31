
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.89.0"
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

variable "client_id" {
  default = "27f2e228-52f3-4aac-b63e-f04f7a53a0a4"
}
variable "client_secret" {
  default = "fZD8Q~tgwVPymO0w~5oIFSOLgQsnMpAupvgjMdoT"
}

variable "tenant_id" {
  default = "28336afb-cc13-4e5d-800f-0ddf83ddfa97"
}

variable "subscription_id" {
  default = "aeb169ae-7f30-4c18-b471-10b5e06576ed"
}

variable "rsg" {
  type = map(string)
  default = {
    "manage-rsg"      = "Japan East"
    "application-rsg" = "Japan West"
  }
}

module "rsg" {
  source = "./modules/ResourceGRP"
  rsg    = {}
}