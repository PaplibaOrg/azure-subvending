output "subscription_id" {
  description = "The ID of the subscription"
  value       = azurerm_subscription.this.id
}

output "subscription_name" {
  description = "The display name of the subscription"
  value       = azurerm_subscription.this.subscription_name
}

output "subscription_alias" {
  description = "The alias of the subscription"
  value       = azurerm_subscription.this.alias
}


