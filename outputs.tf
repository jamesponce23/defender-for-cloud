output "defender_plan_tiers" {
  description = "Current tier per Defender for Cloud resource_type, for a quick sanity check that nothing drifted to Standard unintentionally."
  value       = { for k, v in azurerm_security_center_subscription_pricing.plan : k => v.tier }
}

output "security_contact_email" {
  value = azurerm_security_center_contact.primary.email
}
