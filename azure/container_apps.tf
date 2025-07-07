resource "azurerm_container_app_environment" "shukawam_acp_env" {
  name                = "shukawam-acp-env"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
}

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

# resource "azurerm_container_app" "shukawam-kong-gw" {
#   name                         = "shukawam-kong-gw"
#   container_app_environment_id = azurerm_container_app_environment.shukawam_acp_env.id
#   resource_group_name          = azurerm_resource_group.shukawam_resource_group.name
#   revision_mode                = "Single"
#   template {
#     container {
#       name   = "kong-gateway"
#       image  = "kong/kong-gateway:3.10"
#       cpu    = "1"
#       memory = "2Gi"
#       env {
#         name = "KONG_ROLE"
#         value = "data_plane"
#       }
#       env {secret_name = ""}
#     }
#   }
# }
