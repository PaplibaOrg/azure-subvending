locals {
  # Recursively find all JSON files at any depth using ** pattern
  json_files = fileset("${path.module}", "**/*.json")

  # Decode JSON once per file and filter out files that don't have required fields
  raw_json_files = {
    for file in local.json_files :
    file => jsondecode(file("${path.module}/${file}"))
    if can(jsondecode(file("${path.module}/${file}")).subscription_name) &&
    can(jsondecode(file("${path.module}/${file}")).management_group)
  }

  # Final map used for for_each - use subscription_name as key, include file path
  json_object_map = {
    for key, json_data in local.raw_json_files :
    json_data.subscription_name => merge(json_data, { file_path = key })
  }

  # Determine if subscription is platform based on file path containing "platform"
  is_platform = {
    for key, data in local.json_object_map :
    key => contains(data.file_path, "platform/")
  }
}

module "subscription_platform" {
  source              = "../../modules/services/platform-landing-zone"
  for_each            = { for k, v in local.json_object_map : k => v if local.is_platform[k] }
  subscription_name   = each.value.subscription_name
  subscription_id     = lookup(each.value, "subscription_id", null)
  management_group_id = each.value.management_group
  tags                = lookup(each.value, "tags", {})
  budget              = lookup(each.value, "budget", { enabled = false, amount = 10, time_grain = "Quarterly", contact_emails = [] })
  location            = lookup(each.value, "location", "East US")
}

module "subscription_standard" {
  source              = "../../modules/services/standard-landing-zone"
  for_each            = { for k, v in local.json_object_map : k => v if !local.is_platform[k] }
  subscription_name   = each.value.subscription_name
  subscription_id     = lookup(each.value, "subscription_id", null)
  management_group_id = each.value.management_group
  tags                = lookup(each.value, "tags", {})
  budget              = lookup(each.value, "budget", { enabled = false, amount = 10, time_grain = "Quarterly", contact_emails = [] })
  location            = lookup(each.value, "location", "East US")
}
