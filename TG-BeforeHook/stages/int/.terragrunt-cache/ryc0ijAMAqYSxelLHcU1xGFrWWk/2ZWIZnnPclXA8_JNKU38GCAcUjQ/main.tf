# Ensure Azure CLI Connection: az login
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.95.0"
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

# Resource Group and Storage Account
resource "azurerm_resource_group" "TG-RG" {
  name     = "Terragrunt-ResourceGroup-${var.stage}" 
  location = "westeurope"
  tags     = {
    t1 = "abc"
    t2 = "def"
    t3 = "xyz"
    stage = var.stage
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags, 
    ]
  }  
}

