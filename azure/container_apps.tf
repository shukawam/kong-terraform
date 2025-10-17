resource "azurerm_container_app_environment" "shukawam_container_app_environment" {
  name                       = "shukawam-container-app-environment"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.shukawam_resource_group.name
  logs_destination           = "log-analytics"
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
      name   = "opentelemetry-collector"
      image  = "otel/opentelemetry-collector-contrib:0.137.0"
      cpu    = "0.25"
      memory = "0.5Gi"
      args   = ["--config=/etc/otelcol-contrib/config.yaml"]
      env {
        name        = "CONNECTION_STRING"
        secret_name = "connection-string"
      }
      volume_mounts {
        name = "otel-config"
        path = "/etc/otelcol-contrib"
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
        name        = "KONG_CLUSTER_CONTROL_PLANE"
        secret_name = "kong-cluster-control-plane"
      }
      env {
        name        = "KONG_CLUSTER_SERVER_NAME"
        secret_name = "kong-cluster-server-name"
      }
      env {
        name        = "KONG_CLUSTER_TELEMETRY_ENDPOINT"
        secret_name = "kong-cluster-telemetry-endpoint"
      }
      env {
        name        = "KONG_CLUSTER_TELEMETRY_SERVER_NAME"
        secret_name = "kong-cluster-telemetry-server-name"
      }
      env {
        name        = "KONG_CLUSTER_CERT"
        secret_name = "kong-cluster-cert"
      }
      env {
        name        = "KONG_CLUSTER_CERT_KEY"
        secret_name = "kong-cluster-cert-key"
      }
      env {
        name        = "KONG_CLUSTER_CA_CERT"
        secret_name = "kong-cluster-ca-cert"
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
      env {
        name  = "KONG_STATUS_LISTEN"
        value = "0.0.0.0:8100"
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
  secret {
    name                = "connection-string"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/connection-string/37617b9cee4242aebfe90a7f62a3276c"
  }
  secret {
    name                = "kong-cluster-control-plane"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-control-plane/447bad6f8a4c4ebea66ca2285ae36c4f"
  }
  secret {
    name                = "kong-cluster-server-name"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-server-name/179b083a15c84c5a8adafab8fb0403ba"
  }
  secret {
    name                = "kong-cluster-telemetry-endpoint"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-telemetry-endpoint/6630603a7b004171a7f5cb97762dc17e"
  }
  secret {
    name                = "kong-cluster-telemetry-server-name"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-telemetry-server-name/978900708d42446382485d24e5753192"
  }
  secret {
    name                = "kong-cluster-cert"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-cert/1f9ce65285a948c0af7ed05c9d15f1c0"
  }
  secret {
    name                = "kong-cluster-cert-key"
    identity            = var.user_id
    key_vault_secret_id = "https://shukawam-kv.vault.azure.net/secrets/kong-cluster-cert-key/25e83e742b3842709aaee1e46e6ce678"
  }
}

resource "azurerm_monitor_diagnostic_setting" "shukawam_kong_gateway_logs" {
  name                       = "shukawam-kong-gateway-diagnostic"
  target_resource_id         = azurerm_container_app_environment.shukawam_container_app_environment.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.shukawam_log_analytics_workspace.id
  enabled_log {
    category = "ContainerAppConsoleLogs"
  }
  enabled_log {
    category = "ContainerAppSystemLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}
