output "id" {
  description = "The ID of the consumption budget"
  value       = azurerm_consumption_budget_subscription.budget.id
}

output "name" {
  description = "The name of the consumption budget"
  value       = azurerm_consumption_budget_subscription.budget.name
}

