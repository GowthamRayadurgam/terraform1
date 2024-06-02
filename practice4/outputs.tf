output "Vnet-name" {
  value = module.virtual_networks
}

output "rsg-name" {
  value = { for i, j in var.resource_groups : i => j.location}
}

output "rsg-names" {
  value = keys(var.resource_groups)
}

output "rsg-location" {
  value = values(var.resource_groups)
}

output "vnet-names" {
  value = values(var.virtual_networks)
}
