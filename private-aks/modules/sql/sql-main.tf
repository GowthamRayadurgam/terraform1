resource "azurerm_mssql_server" "ms-sql" {
  name = var.mssql_name
  resource_group_name = var.resource_group_name
  location = var.location
  version = "12.0"
  administrator_login = "gowtham"
  administrator_login_password = var.administrator_login_password
  public_network_access_enabled = false
  outbound_network_restriction_enabled = false

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_database" "sql_DB" {
  name = "mssql_DB"
  server_id = azurerm_mssql_server.ms-sql.id
#  max_size_gb = var.DB_max_size
  read_scale = false
  sku_name = var.db_sku
  zone_redundant = false
  maintenance_configuration_name = "SQL_Default"
  storage_account_type = "Local"

/*
  short_term_retention_policy {
    retention_days = "7"
  }
/*  lifecycle {
    prevent_destroy = true
  }

*/
}