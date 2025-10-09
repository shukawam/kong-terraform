resource "azurerm_key_vault" "shukawam_key_vault" {
  name                = "shukawam-key-vault"
  location            = var.location
  resource_group_name = azurerm_resource_group.shukawam_resource_group.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
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
  }
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
