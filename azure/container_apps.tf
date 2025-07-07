# resource "azurerm_container_app_environment" "shukawam_acp_env" {
#   name                = "shukawam-acp-env"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.shukawam_resource_group.name
# }

# resource "azurerm_container_app" "shukawam_acp" {
#   name                         = "shukawam-acp"
#   container_app_environment_id = azurerm_container_app_environment.shukawam_acp_env.id
#   resource_group_name          = azurerm_resource_group.shukawam_resource_group.name
#   revision_mode                = "Single"
#   template {
#     container {
#       name   = "gin-api"
#       image  = "kennethreitz/httpbin:latest"
#       cpu    = "0.25"
#       memory = "0.5Gi"
#     }
#   }
# }
