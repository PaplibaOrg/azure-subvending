data "azurerm_subscriptions" "lookup" {
  count = var.subscription_id == null ? 1 : 0
}

locals {
  # Look up subscription_id by name if not provided
  subscription_id = var.subscription_id != null ? var.subscription_id : try([
    for sub in data.azurerm_subscriptions.lookup[0].subscriptions : sub.subscription_id
    if sub.display_name == var.subscription_name
  ][0], null)
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
