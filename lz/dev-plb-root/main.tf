locals {
  # Recursively find all JSON files at any depth using ** pattern
  json_files = fileset("${path.module}", "**/*.json")

  # # Decode JSON once per file and filter out files that don't have required fields
  # raw_json_files = {
  #   for file in local.json_files :
  #   file => jsondecode(file("${path.module}/${file}"))
  #   if can(jsondecode(file("${path.module}/${file}")).subscription_name) &&
  #   can(jsondecode(file("${path.module}/${file}")).management_group)
  # }
  #
  # # Final map used for for_each - use subscription_name as key
  # json_object_map = {
  #   for key, json_data in local.raw_json_files :
  #   json_data.subscription_name => json_data
  # }
}

# module "subscription" {
#   source              = "../../modules/services/landing-zone"
#   for_each            = local.json_object_map
#   subscription_name   = each.value.subscription_name
#   subscription_id     = lookup(each.value, "subscription_id", null)
#   management_group_id = each.value.management_group
# }

output "print" {
  value = local.json_files
  # description = description
}
