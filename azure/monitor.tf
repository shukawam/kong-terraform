resource "azurerm_monitor_workspace" "shukawam_azure_monitor_workspace" {
  name                = "shukawam-azure-monitor-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
}

resource "azurerm_log_analytics_workspace" "shukawam_log_analytics_workspace" {
  name                = "shukawam-log-analytics-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
}

resource "azurerm_application_insights" "shukawam_application_insights" {
  name                = "shukawam-application-insights"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
  application_type    = "web"
}

# Monitor Diagnostic Setting for Container App to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "shukawam_container_app_env_diagnostic_setting" {
  name                       = "shukawam-kong-gateway-logs"
  target_resource_id         = azurerm_container_app_environment.shukawam_container_app_environment.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shukawam_log_analytics_workspace.id
  enabled_log {
    category = "ContainerAppConsoleLogs"
  }
  enabled_log {
    category = "ContainerAppSystemLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "shukawam_container_app_diagnostic_setting" {
  name                       = "shukawam-kong-gateway-logs"
  target_resource_id         = azurerm_container_app.shukawam-kong-gateway.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shukawam_log_analytics_workspace.id
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
