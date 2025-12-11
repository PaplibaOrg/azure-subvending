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

output "mi_resource_group_name" {
  description = "The name of the Managed Identity resource group"
  value       = module.resource_group_mi.name
}

output "tfstate_resource_group_name" {
  description = "The name of the Terraform state resource group"
  value       = module.resource_group_tfstate.name
}

output "platform_resources_resource_group_name" {
  description = "The name of the platform resources resource group"
  value       = module.resource_group_platform_resources.name
}
