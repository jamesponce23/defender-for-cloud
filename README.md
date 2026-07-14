# Defender for Cloud (Terraform)

Infrastructure-as-code for Microsoft Defender for Cloud plan configuration
and security contact settings, on a currently-bare Azure subscription (no
VMs, storage, SQL, etc. deployed yet).

## Cost posture — read this before changing anything

Every plan in `defender_plans.tf` defaults to **`"Free"`** in `variables.tf`.
Applying this project as-is costs **$0** — you're only configuring settings,
not deploying billable resources.

| Resource type | Free tier | What "Standard" costs (approximate — verify on Azure's pricing page before enabling) |
|---|---|---|
| `VirtualMachines` (Defender for Servers) | Basic recommendations | ~$15/server/month |
| `AppServices` | Basic recommendations | ~$15/instance/month |
| `SqlServers` | Basic recommendations | ~$15/vCore/month |
| `StorageAccounts` | Basic recommendations | Per-transaction/GB, has a free monthly allowance |
| `KeyVaults` | Basic recommendations | Per 10k transactions |
| `Containers` | Basic recommendations | Per vCore-hour |
| `Arm` (Resource Manager) | Basic recommendations | Low flat rate, bills per subscription |
| `Dns` | Basic recommendations | Per million queries |

**Deliberately not managed here:** `resource_type = "CloudPosture"` (paid
Defender CSPM). Unlike everything above, it bills a **flat per-subscription
fee regardless of resource count** — the one plan that would charge you on a
completely empty subscription. The free "foundational CSPM" posture
recommendations are already on by default for every subscription with no
Terraform needed.

**Rule of thumb:** only flip a `defender_plans` entry to `"Standard"` in
`terraform.tfvars` once you actually have a matching resource deployed
(e.g. flip `VirtualMachines` to `Standard` once you have a VM worth
protecting). Standard tiers bill per-resource, so an empty subscription with
everything flipped to Standard still costs $0 in practice — but leave things
at `Free` until there's something real to protect, and re-check current
pricing at https://azure.microsoft.com/pricing/details/defender-for-cloud/
since it changes over time.

## Layout

```
main.tf                 terraform block + azurerm remote backend
providers.tf             azurerm provider (subscription + tenant pinned)
variables.tf              defender_plans map, security contact vars
defender_plans.tf         azurerm_security_center_subscription_pricing, one per resource type
security_contact.tf       azurerm_security_center_contact (free, just routes alert emails)
outputs.tf                 current tier per plan, for a quick drift check
terraform.tfvars.example   template
```

## Backend

Remote state lives in the same Azure Storage account as
`entra-zero-trust-baseline`, under a separate key so the two projects don't
collide:

```
storage account: <your-tfstate-storage-account>
container:       tfstate
key:             defender-for-cloud.tfstate
```

## Authentication

Uses your `az login` session directly — Defender for Cloud pricing and
security contact settings are Azure Resource Manager (control-plane)
operations, not Microsoft Graph, so subscription Owner is sufficient. No
service principal needed here (unlike `entra-zero-trust-baseline`'s
PIM-for-Groups requirement).

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # fill in your email
terraform init
terraform plan     # confirm everything stays at $0 / Free before applying
terraform apply
```
