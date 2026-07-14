variable "defender_plans" {
  description = <<-EOT
    Defender for Cloud plan tier per resource type. Kept at "Free" by default
    because this subscription is bare — no VMs, storage, SQL, etc. deployed
    yet. Only flip an entry to "Standard" once you actually have a matching
    resource to protect; each Standard plan bills per-resource/month (see
    README.md for the current per-plan pricing).
  EOT
  type        = map(string)
  default = {
    VirtualMachines  = "Free" # Defender for Servers
    AppServices      = "Free" # Defender for App Service
    SqlServers       = "Free" # Defender for SQL
    StorageAccounts  = "Free" # Defender for Storage
    KeyVaults        = "Free" # Defender for Key Vault
    Containers       = "Free" # Defender for Containers
    Arm              = "Free" # Defender for Resource Manager
    Dns              = "Free" # Defender for DNS
  }

  validation {
    condition     = alltrue([for tier in values(var.defender_plans) : contains(["Free", "Standard"], tier)])
    error_message = "Each defender_plans value must be \"Free\" or \"Standard\"."
  }
}

variable "security_contact_email" {
  description = "Email address to receive Defender for Cloud security alerts and notifications. Free to configure — no cost."
  type        = string
}

variable "security_contact_phone" {
  description = "Optional phone number for the security contact."
  type        = string
  default     = null
}
