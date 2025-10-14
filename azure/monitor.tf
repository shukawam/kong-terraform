resource "azurerm_monitor_workspace" "shukawam_azure_monitor_workspace" {
  name                = "shukawam-azure-monitor-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
}

resource "azurerm_monitor_aad_diagnostic_setting" "shukawam_aad_diagnostic_setting" {
  name                       = "shukawam-aad-diagnostic-setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shukawam_log_analytics_workspace.id
  enabled_log {
    category = "ContainerAppConsoleLogs"
    retention_policy {
      enabled = true
      days    = 7
    }
  }
  enabled_log {
    category = "ContainerAppSystemLogs"
    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

resource "azurerm_log_analytics_workspace" "shukawam_log_analytics_workspace" {
  name     = "shukawam-log-analytics-workspace"
  location = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
  retention_in_days = 30
} 

resource "azurerm_application_insights" "shukawam_application_insights" {
  name                = "shukawam-application-insights"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
  application_type    = "web"
}
