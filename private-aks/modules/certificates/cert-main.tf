resource "azurerm_key_vault_certificate" "kv_cert" {
  name = var.cert_name
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64(var.certificate_path)
    password = var.certificate_passwd
  }
}

resource "azurerm_key_vault_certificate_contacts" "example" {
  key_vault_id = azurerm_key_vault.kv.id

  contact {
    email = "gowthi15@gmail.com"
  }

  depends_on = [
    azurerm_key_vault_access_policy.kv_access
  ]
}