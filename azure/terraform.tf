terraform {
  required_version = "1.12.2"
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.35.0"
    }
  }
  cloud {
    organization = "shukawam"
    workspaces {
      project = "Kong"
      name    = "azure"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
