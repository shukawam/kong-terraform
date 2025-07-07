resource "azurerm_resource_group" "shukawam_resource_group" {
  name     = "shukawam-kong-container-apps"
  location = var.location
}
