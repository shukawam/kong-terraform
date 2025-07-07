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

resource "azurerm_container_app" "shukawam-kong-gw" {
  name                         = "shukawam-kong-gw"
  container_app_environment_id = azurerm_container_app_environment.shukawam_acp_env.id
  resource_group_name          = azurerm_resource_group.shukawam_resource_group.name
  revision_mode                = "Single"
  template {
    container {
      name   = "kong-gateway"
      image  = "kong/kong-gateway:3.10"
      cpu    = "1"
      memory = "2Gi"
      env {
        name  = "KONG_ROLE"
        value = "data_plane"
      }
      env {
        name  = "KONG_DATABASE"
        value = "off"
      }
      env {
        name  = "KONG_VITALS"
        value = "off"
      }
      env {
        name  = "KONG_CLUSTER_MTLS"
        value = "pki"
      }
      env {
        name  = "KONG_CLUSTER_CONTROL_PLANE"
        value = "d7329eb4dd.us.cp0.konghq.com:443"
      }
      env {
        name  = "KONG_CLUSTER_SERVER_NAME"
        value = "d7329eb4dd.us.cp0.konghq.com"
      }
      env {
        name  = "KONG_CLUSTER_TELEMETRY_ENDPOINT"
        value = "d7329eb4dd.us.tp0.konghq.com:443"
      }
      env {
        name  = "KONG_CLUSTER_TELEMETRY_SERVER_NAME"
        value = "d7329eb4dd.us.tp0.konghq.com"
      }
      env {
        name  = "KONG_CLUSTER_CERT"
        value = var.kong_cluster_cert
      }
      env {
        name  = "KONG_CLUSTER_CERT_KEY"
        value = var.kong_cluster_cert_key
      }
      env {
        name  = "KONG_LUA_SSL_TRUSTED_CERTIFICATE"
        value = "system"
      }
      env {
        name  = "KONG_KONNECT_MODE"
        value = "on"
      }
      env {
        name  = "KONG_CLUSTER_DP_LABELS"
        value = "type:docker-linuxdockerOS"
      }
      env {
        name  = "KONG_ROUTER_FLAVOR"
        value = "expressions"
      }
    }
  }
  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = "8000"
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  secret {}
}
