# Mostrar nombre del grupo de recursos
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Mostrar nombre de la cuenta de almacenamiento
output "storage_account_name" {
  value = azurerm_storage_account.st.name
}

# Mostrar nombre de Data Factory
output "data_factory_name" {
  value = azurerm_data_factory.df.name
}

# Mostrar nombre de la base de datos SQL
output "sql_database_name" {
  value = azurerm_mssql_database.sqldb.name
}
