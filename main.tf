terraform {
  required_version = ">= 1.9"

  backend "azurerm" {
    # resource_group_name + storage_account_name are supplied at init time via
    # -backend-config=backend.hcl (gitignored) — see backend.hcl.example.
    container_name   = "tfstate"
    key              = "defender-for-cloud.tfstate"
    use_azuread_auth = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
