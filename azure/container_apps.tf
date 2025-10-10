resource "azurerm_container_app_environment" "shukawam_container_app_environment" {
  name                       = "shukawam-container-app-environment"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.shukawam_resource_group.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shukawam_log_analytics_workspace.id
}

resource "azurerm_container_app" "shukawam-kong-gateway" {
  name                         = "shukawam-kong-gateway"
  container_app_environment_id = azurerm_container_app_environment.shukawam_container_app_environment.id
  resource_group_name          = azurerm_resource_group.shukawam_resource_group.name
  revision_mode                = "Single"
  template {
    init_container {
      name   = "load-otel-collector-config"
      image  = "busybox:latest"
      cpu    = "0.25"
      memory = "0.5Gi"
      command = [
        "wget",
        "https://raw.githubusercontent.com/shukawam/kong-terraform/refs/heads/main/azure/config/otel-collector-config.yaml",
        "-O",
        "/tmp/config.yaml"
      ]
      volume_mounts {
        name = "otel-config"
        path = "/tmp"
      }
    }
    container {
      name   = "kong-gateway"
      image  = "kong/kong-gateway:3.12"
      cpu    = "0.5"
      memory = "1Gi"
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
        value = var.kong_cluster_control_plane
      }
      env {
        name  = "KONG_CLUSTER_SERVER_NAME"
        value = var.kong_cluster_server_name
      }
      env {
        name  = "KONG_CLUSTER_TELEMETRY_ENDPOINT"
        value = var.kong_cluster_telemetry_endpoint
      }
      env {
        name  = "KONG_CLUSTER_TELEMETRY_SERVER_NAME"
        value = var.kong_cluster_telemetry_server_name
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
      env {
        name  = "KONG_TRACING_INSTRUMENTATIONS"
        value = "all"
      }
      env {
        name  = "KONG_TRACING_SAMPLING_RATE"
        value = "1.0"
      }
    }
    container {
      name   = "otel-collector"
      image  = "otel/opentelemetry-collector-contrib:0.137.0"
      cpu    = "0.5"
      memory = "1Gi"
      env {
        name  = "CONNECTION_STRING"
        value = azurerm_application_insights.shukawam_application_insights.connection_string
      }
      volume_mounts {
        name = "otel-config"
        path = "/etc/otelcol-contrib"
      }
    }
    # Always keep 1 replica to avoid cold start
    min_replicas = 1
    max_replicas = 1
    volume {
      name         = "otel-config"
      storage_type = "EmptyDir"
    }
  }

  # TODO: Use Key Vault to manage secrets
  # secret {
  #   name                = "konnect-cluster-control-plane"
  #   key_vault_secret_id = azurerm_key_vault_secret.kong_cluster_control_plane.id
  # }
  # secret {
  #   name                = "konnect-cluster-server-name"
  #   key_vault_secret_id = azurerm_key_vault_secret.kong_cluster_server_name.id
  # }
  # secret {
  #   name                = "konnect-cluster-telemetry-endpoint"
  #   key_vault_secret_id = azurerm_key_vault_secret.kong_cluster_telemetry_endpoint.id
  # }
  # secret {
  #   name                = "konnect-cluster-telemetry-server-name"
  #   key_vault_secret_id = azurerm_key_vault_secret.kong_cluster_telemetry_server_name.id
  # }
  # secret {
  #   name                = "konnect-cluster-cert"
  #   key_vault_secret_id = azurerm_key_vault_secret.konnect_cluster_cert.id
  # }
  # secret {
  #   name                = "konnect-cluster-cert-key"
  #   key_vault_secret_id = azurerm_key_vault_secret.konnect_cluster_cert_key.id
  # }
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
}
