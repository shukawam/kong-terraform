resource "azurerm_key_vault" "shukawam_key_vault" {
  name                        = "shukawam-kv"
  location                    = azurerm_resource_group.shukawam_resource_group.location
  resource_group_name         = azurerm_resource_group.shukawam_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.client_id
    key_permissions = [
      "Get",
    ]
    secret_permissions = [
      "Get", "Set", "Delete", "Purge", "Recover"
    ]
    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "konnect_cluster_cert" {
  name         = "konnect-cluster-cert"
  value        = var.kong_cluster_cert
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
}

resource "azurerm_key_vault_secret" "konnect_cluster_cert_key" {
  name         = "konnect-cluster-cert-key"
  value        = var.kong_cluster_cert_key
  key_vault_id = azurerm_key_vault.shukawam_key_vault.id
}
