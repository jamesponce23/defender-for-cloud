# Deliberately NOT managing resource_type = "CloudPosture" (the paid Defender
# CSPM plan) here. Unlike the per-resource plans below, it bills a flat
# per-subscription fee regardless of whether any resources exist — the one
# Defender plan that would cost money on a completely empty subscription.
# The free "foundational CSPM" recommendations are already on by default for
# every subscription at no cost, with nothing to deploy.

resource "azurerm_security_center_subscription_pricing" "plan" {
  for_each = var.defender_plans

  tier          = each.value
  resource_type = each.key
}
