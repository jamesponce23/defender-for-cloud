terraform {
  required_version = ">= 1.9"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "<your-tfstate-storage-account>"
    container_name        = "tfstate"
    key                   = "defender-for-cloud.tfstate"
    use_azuread_auth      = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
