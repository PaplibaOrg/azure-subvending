locals {
  # Read all JSON files in subdirectories
  json_object_map = {
    for file in fileset(path.module, "*/*.json") :
    "${split("/", file)[0]}/${jsondecode(file(file)).application}/${jsondecode(file(file)).environment}/${jsondecode(file(file)).sequence}" => jsondecode(file(file))
  }
}

module "subscription" {
  source = "../modules/services/subscriptions"

  for_each = local.json_object_map

  application         = each.value.application
  environment         = each.value.environment
  sequence            = each.value.sequence
  location            = each.value.location
  billing_scope_id    = each.value.billing_scope_id
  management_group_id = each.value.management_group_id
  tags                = each.value.tags
  additional_tags     = lookup(each.value, "additional_tags", {})
}
