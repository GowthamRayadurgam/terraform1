resource "azurerm_key_vault" "kv" {
  name = var.kv_name
  location = var.location
  resource_group_name = var.resource_group_name
  tenant_id = var.tenant_id
  sku_name = var.sku_name
  soft_delete_retention_days = 7
  purge_protection_enabled = false

  access_policy = {}
}

resource "azurerm_key_vault_access_policy" "kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = var.tenant_id
  object_id = var.object_id

  key_permissions = var.key_permissions
  secret_permissions = var.secret_permissions
  certificate_permissions = var.certificate_permissions
  storage_permissions = var.storage_permissions
}

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