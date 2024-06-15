variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [each.value.address_prefix]
}

locals {
  subnet1_in_vnet2 = [for i, j in azurerm_subnet.subnet : j.id if i == "subnet1" && j.virtual_network_name == "vnet2"]
}


output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet1_id_in_vnet2" {
  value = local.subnet1_in_vnet2
}



/*
variable "virtual_networks" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefix = string
    }))
  }))
}

resource "azurerm_virtual_network" "vnet" {
    for_each = {for rg_key, vnets in var.virtual_networks : rg_key => vnets}
    name = each.key
    resource_group_name = azurerm_resource_group.rg[each.key].name
    location = azurerm_resource_group.rg[each.value].location
    address_space = each.value.address_space
}

resource "azurerm_subnet" "subnet" {
    for_each = { for rg_key, vnets in var.virtual_networks : rg_key => flatten([for vnet_key, vnet in vnets : {for subnet_key, subnet in vnet.subnets : vnet_key => subnet_key}]) }
    name = each.value.vnet_key
    address_prefixes = [each.value.subnets.each.key]
    resource_group_name = azurerm_virtual_network.vnet[each.key].resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet[each.key].name
}
*/