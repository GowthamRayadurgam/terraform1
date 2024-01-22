output "storage-access-tire" {
  value = azurerm_storage_account.backend-storage.access_tier
}

output "public-ip" {
  value = module.public-ip-1.Public-IP
}