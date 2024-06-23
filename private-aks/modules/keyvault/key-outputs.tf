output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "cert_secret_id" {
  value = azurerm_key_vault_certificate.kv_cert.secret_id
}