locals {
  # Map Azure location to region short code
  location_to_region = {
    "eastus" = "eus"
    "westus" = "wus"
    "centralus" = "cus"
    # Add more mappings as needed
  }

  region = local.location_to_region[var.location]

  # Construct subscription name: sub-{app}-{region}-{env}-{seq}
  subscription_name = "sub-${var.application}-${local.region}-${var.environment}-${var.sequence}"

  # Convert tags object to map(string) for Azure
  tags_map = merge(
    {
      environment = var.environment
      managedBy   = "terraform"
    },
    var.tags
  )
}

module "subscription" {
  source = "../../resources/subscription"

  subscription_name   = local.subscription_name
  billing_scope_id    = var.billing_scope_id
  management_group_id = var.management_group_id
  tags                = local.tags_map
}


