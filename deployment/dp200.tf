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
