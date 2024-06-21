output "mssql_login" {
  value = azurerm_mssql_server.ms-sql.administrator_login
}

output "mssql_id" {
  value = azurerm_mssql_server.ms-sql.id
}