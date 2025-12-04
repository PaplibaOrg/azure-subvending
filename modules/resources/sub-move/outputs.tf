output "id" {
  description = "The ID of the management group subscription association"
  value       = azurerm_management_group_subscription_association.sub_move.id
}

output "management_group_id" {
  description = "The management group ID"
  value       = azurerm_management_group_subscription_association.sub_move.management_group_id
}

output "subscription_id" {
  description = "The subscription ID"
  value       = azurerm_management_group_subscription_association.sub_move.subscription_id
}
