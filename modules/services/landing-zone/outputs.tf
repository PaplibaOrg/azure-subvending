output "subscription_alias" {
  description = "The alias of the subscription"
  value       = module.subscription.subscription_alias
}

output "subscription_id" {
  description = "The ID of the subscription"
  value       = module.subscription.subscription_id
}

output "subscription_name" {
  description = "The display name of the subscription"
  value       = module.subscription.subscription_name
}

output "management_group_id" {
  description = "The management group ID where the subscription is associated"
  value       = module.sub_move.management_group_id
}
