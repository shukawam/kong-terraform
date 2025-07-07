resource "azurerm_resource_group" "shukawam_resource_group" {
  location = var.location
  name     = "shukawam-kong-container-apps"
}
