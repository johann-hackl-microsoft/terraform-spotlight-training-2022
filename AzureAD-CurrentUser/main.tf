# Ensure Azure CLI Connection: az login
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.95.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.18.0"
    }    
  }
  # use local state
  backend "local" {
  }
}

# Provider for current Azure subscription
provider "azurerm" {
  features {}
}

# Provider for current Azure AD tenant
provider "azuread" {
}

# get current user
data "azurerm_client_config" "current" {}
data "azuread_service_principals" "current" {
  object_ids     = [data.azurerm_client_config.current.object_id]
  ignore_missing =  true
}
data "azuread_users" "current" {
  object_ids     = [data.azurerm_client_config.current.object_id]
  ignore_missing = true
}
locals {
  # either current user or service principal
  current_identity_name = length(data.azuread_service_principals.current.service_principals) == 0 ? data.azuread_users.current.users[0].user_principal_name : data.azuread_service_principals.current.service_principals[0].display_name
}

# show current user
output "current_client_object_id" {
  value       = data.azurerm_client_config.current.object_id
}
output "current_current_identity_name" {
  value       = local.current_identity_name
}