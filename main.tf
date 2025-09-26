# Proveedor de Azure
provider "azurerm" {
  features {}
  
  subscription_id = "removed-for-safety"
  client_id       = "removed-for-safety"
  client_secret   = "removed-for-safety"
  tenant_id       = "removed-for-safety"
  
}

# Crear grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-pipeline-demo"
  location = "East US"
}

# Crear cuenta de almacenamiento
resource "azurerm_storage_account" "st" {
  name                     = "storagepipeline123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Crear Data Factory
resource "azurerm_data_factory" "df" {
  name                = "dfpipeline123"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Crear servidor SQL
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sqlserverpipeline123eastus2"   #  nombre nuevo
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "eastus2"
  version                      = "12.0"
  administrator_login          = "removed-for-safety"
  administrator_login_password = "removed-for-safety"
}



# Crear base de datos SQL
resource "azurerm_mssql_database" "sqldb" {
  name      = "sqldbpipeline"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "S0"
}

# --- Azure Databricks Workspace ---
resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbw-pipeline-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location  # quedará en la misma región del RG (eastus)
  sku                 = "standard"                          # opciones: "standard", "premium", "trial"
  
   managed_resource_group_name = "databricks-rg-pipeline-demo"
}

