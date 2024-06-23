terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }

  
  subscription_id = "6a02c723-570d-4206-ba27-b7b09bfeeb35"
  client_id       = "107ea390-d996-40b7-a339-72dd4c714ba5"
  client_secret   = "Gnh8Q~GgxSd.iYkbxV7_X6k3Oti6cyesIFS6UcQP"
  tenant_id       = "44637267-515d-4b7d-af99-89581adde1b8"
}