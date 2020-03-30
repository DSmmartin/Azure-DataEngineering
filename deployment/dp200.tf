resource "azurerm_resource_group" "main_dp200_rg" {
  name     = "azure_data_engineer_dp200"
  location = "West Europe"
}

data "azurerm_client_config" "current" {
}

resource "azurerm_databricks_workspace" "dp200_databricks" {
  name                = "dp200db"
  resource_group_name = azurerm_resource_group.main_dp200_rg.name
  location            = azurerm_resource_group.main_dp200_rg.location
  sku                 = "trial"
}

resource "azurerm_data_factory" "dp200_datafactory" {
  name                = "dp200dfmmartin"
  location            = azurerm_resource_group.main_dp200_rg.location
  resource_group_name = azurerm_resource_group.main_dp200_rg.name
}

resource "azurerm_storage_account" "dp200_storage" {
  name                     = "dp200st"
  resource_group_name      = azurerm_resource_group.main_dp200_rg.name
  location                 = azurerm_resource_group.main_dp200_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = "true"
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "dp200_df_link2storage" {
  name                  = "storageraw"
  resource_group_name   = azurerm_resource_group.main_dp200_rg.name
  data_factory_name     = azurerm_data_factory.dp200_datafactory.name
  service_principal_id  = data.azurerm_client_config.current.client_id
  service_principal_key = var.AZURE_CLIENT_SECRET
  tenant                = var.AZURE_TENANT_ID
  url                   = "https://dp200st.dfs.core.windows.net"
}
