locals {
  json_files = fileset("${path.module}", "**/*.json")
}

# module "subscription" {
#   source = "../../modules/services/subscriptions"
#   for_each = local.json_object_map
#   application         = each.value.application
#   environment         = each.value.environment
#   sequence            = each.value.sequence
#   location            = each.value.location
#   billing_scope_id    = each.value.billing_scope_id
#   management_group_id = each.value.management_group_id
#   tags                = each.value.tags
# }

output "output_name" {
  value = local.json_files
}
