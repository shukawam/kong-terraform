resource "azurerm_monitor_workspace" "shukawam_azure_monitor_workspace" {
  name                = "shukawam-azure-monitor-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
}
