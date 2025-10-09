resource "azurerm_key_vault" "shukawam_key_vault" {
  name                = "shukawam-key-vault"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  access_policy {
    tenant_id      = data.azurerm_client_config.current.tenant_id
    object_id      = data.azurerm_client_config.current.object_id
    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]
    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
      "Release",
      "Rotate",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]
    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
    storage_permissions = [
      "Backup",
      "Delete",
      "DeleteSAS",
      "Get",
      "List",
      "ListSAS",
      "Purge",
      "Recover",
      "RegenerateKey",
      "Restore",
      "Set",
      "SetSAS",
      "Update"
    ]
  }
}

resource "azurerm_key_vault_secret" "kong_cluster_control_plane" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-control-plane"
  value        = var.kong_cluster_control_plane
}

resource "azurerm_key_vault_secret" "kong_cluster_server_name" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-server-name"
  value        = var.kong_cluster_server_name
}

resource "azurerm_key_vault_secret" "kong_cluster_telemetry_endpoint" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-telemetry-endpoint"
  value        = var.kong_cluster_telemetry_endpoint
}

resource "azurerm_key_vault_secret" "kong_cluster_telemetry_server_name" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-telemetry-server-name"
  value        = var.kong_cluster_telemetry_server_name
}
resource "azurerm_key_vault_secret" "kong_cluster_cert" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-cert"
  value        = var.kong_cluster_cert
}

resource "azurerm_key_vault_secret" "kong_cluster_cert_key" {
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
  name         = "kong-cluster-cert-key"
  value        = var.kong_cluster_cert_key
}
