locals {
  # Recursively find all JSON files at any depth using ** pattern
  json_files = fileset("${path.module}", "**/*.json")

  # Decode JSON once per file
  raw_json_files = {
    for file in local.json_files :
    file => jsondecode(file("${path.module}/${file}"))
  }

  # Final map used for for_each
  json_object_map = {
    for key, json_data in local.raw_json_files :
    "${json_data.application}/${json_data.environment}/${json_data.sequence}" => json_data
  }
}

module "subscription" {
  source = "../../modules/services/landing-zone"
  for_each = local.json_object_map
  prefix               = "test-plb"
  application          = each.value.application
  environment          = each.value.environment
  sequence             = each.value.sequence
  billing_account_name = each.value.billing_account_name
  billing_profile_name = each.value.billing_profile_name
  invoice_section_name = each.value.invoice_section_name
  management_group_id  = each.value.management_group
  workload             = each.value.workload
  tags                 = each.value.tags
}

