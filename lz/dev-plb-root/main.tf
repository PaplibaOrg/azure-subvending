locals {
  json_object_map = {
    for file in fileset("${path.module}", "**/*.json") :
    "${file}" => jsondecode(file(file))
  }
}

# module "subscription" {
#   source = "../../modules/services/subscriptions"
# }

# module "subscription" {
#   source = "../../modules/services/subscriptions" for_each = local.json_object_map
#   application         = each.value.application
#   environment         = each.value.environment
#   sequence            = each.value.sequence
#   location            = each.value.location
#   billing_scope_id    = each.value.billing_scope_id
#   management_group_id = each.value.management_group_id
#   tags                = each.value.tags
# }

# output "output_name" {
#   value = local.json_f
# }

output "output_name" {
  value = local.json_object_map
}
