module "subscription" {
  source               = "../../resources/subscription"
  subscription_name    = "plb-${var.application}-${var.environment}-${var.sequence}"
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
  management_group_id  = var.management_group_id
  workload             = var.workload
  tags                 = var.tags
}
