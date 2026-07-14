# Free to configure regardless of plan tiers — just routes alert
# notifications, no billing impact.
resource "azurerm_security_center_contact" "primary" {
  name  = "primary"
  email = var.security_contact_email
  phone = var.security_contact_phone

  alert_notifications = true
  alerts_to_admins    = true
}
