output "mssql_login" {
  value = azurerm_mssql_server.ms-sql.administrator_login
}

output "mssql_server_id" {
  value = azurerm_mssql_server.ms-sql.id
}

output "mssql_database_id" {
  value = azurerm_mssql_database.sql_DB.id
}
