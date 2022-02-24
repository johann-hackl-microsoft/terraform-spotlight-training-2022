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
      #TF_VAR_tg_rg_lifecycle_ignore_changes#
    ]
  }  
}

