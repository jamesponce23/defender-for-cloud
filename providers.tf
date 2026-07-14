# Authenticates via your `az login` session (Azure CLI credentials).
# Defender for Cloud pricing/contact settings are Azure Resource Manager
# (control-plane) operations, not Microsoft Graph, so your subscription
# Owner role is sufficient here — no service principal needed, unlike
# the entra-zero-trust-baseline project's PIM-for-Groups requirement.
provider "azurerm" {
  subscription_id = "c84f3a40-897d-4cdf-b42a-51ea92909d4b"
  tenant_id       = "4e742c1b-da7f-4019-9607-9a39dda80577"

  # Skip Terraform's default behavior of trying to auto-register all ~60+
  # resource providers it supports on first use — slow, and unnecessary here
  # since Microsoft.Security (the only one this project touches) is already
  # registered on this subscription.
  resource_provider_registrations = "none"

  features {}
}
