output "fqdn" {
  value = "https://${azurerm_container_app.shukawam-kong-gateway.latest_revision_fqdn}"
}
