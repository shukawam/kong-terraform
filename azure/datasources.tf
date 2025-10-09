data "azurerm_client_config" "current" {
}

data "azurerm_user" "console_user" {
  user_principal_name = "shuhei.kawamura@konghq.com"
}
