data "azurerm_subscriptions" "this" {
  count                 = var.subscription_id == null ? 1 : 0
  display_name_contains = var.subscription_name
}

locals {
  # Find subscription with exact name match
  found_subscription = var.subscription_id != null ? null : (
    length(data.azurerm_subscriptions.this) > 0 && length(data.azurerm_subscriptions.this[0].subscriptions) > 0 ?
    [
      for sub in data.azurerm_subscriptions.this[0].subscriptions :
      sub if sub.display_name == var.subscription_name
    ][0] : null
  )

  subscription_id = var.subscription_id != null ? var.subscription_id : (
    local.found_subscription != null ? local.found_subscription.subscription_id : null
  )
}

resource "azurerm_subscription" "this" {
  alias             = var.alias
  subscription_name = var.subscription_name
  subscription_id   = local.subscription_id
}

resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.management_group_id
  subscription_id     = local.subscription_id
}
