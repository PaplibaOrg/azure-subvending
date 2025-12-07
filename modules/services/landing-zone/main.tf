data "azurerm_subscriptions" "lookup" {
  count = var.subscription_id == null ? 1 : 0
}

locals {
  # Look up subscription_id by name if not provided
  subscription_id = var.subscription_id != null ? var.subscription_id : try([
    for sub in data.azurerm_subscriptions.lookup[0].subscriptions : sub.subscription_id
    if sub.display_name == var.subscription_name
  ][0], null)

  # Calculate start date as first day of current month in RFC3339 format
  start_date = "${formatdate("YYYY-MM-01", timestamp())}T00:00:00Z"
}

module "subscription" {
  source            = "../../resources/sub-alias-create"
  alias             = var.subscription_name
  subscription_id   = local.subscription_id
  subscription_name = var.subscription_name
  tags              = var.tags
}

module "sub_move" {
  source              = "../../resources/sub-move"
  management_group_id = var.management_group_id
  subscription_id     = "/subscriptions/${local.subscription_id}"
}

module "budget" {
  count  = var.budget.enabled ? 1 : 0
  source = "../../resources/sub-budget"

  budget_name     = "${var.subscription_name}-budget"
  subscription_id = "/subscriptions/${local.subscription_id}"
  amount          = var.budget.amount
  time_grain      = var.budget.time_grain
  start_date      = local.start_date
  end_date        = "2099-12-31T23:59:59Z"

  notifications = [
    {
      enabled        = true
      threshold      = 100
      operator       = "GreaterThanOrEqualTo"
      threshold_type = "Actual"
      contact_emails = var.budget.contact_emails
    }
  ]
}
