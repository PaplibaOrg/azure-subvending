output "subscription_alias" {
  description = "The alias of the subscription"
  value       = azurerm_subscription.subscription.alias
}

output "subscription_id" {
  description = "The ID of the subscription"
  value       = azurerm_subscription.subscription.id
}

output "subscription_name" {
  description = "The display name of the subscription"
  value       = azurerm_subscription.subscription.subscription_name
}
