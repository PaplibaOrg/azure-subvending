resource "azurerm_subscription" "subscription" {
  alias             = var.alias
  subscription_id   = var.subscription_id
  subscription_name = var.subscription_name
  tags              = var.tags
}
