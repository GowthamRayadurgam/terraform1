variable "rsg-location" {
}

variable "rsg-name" {  
}

resource "azurerm_storage_account" "tf-backend" {
  name = "tfbackend15121"
  location = var.rsg-location
  resource_group_name = var.rsg-name
  account_replication_type = "LRS"
  account_tier = "Standard"
}


resource "azurerm_storage_container" "tf-container" {
  name = "tf-container"
  storage_account_name = "tfbackend15121"
}