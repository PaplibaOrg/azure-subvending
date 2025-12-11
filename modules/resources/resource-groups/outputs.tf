output "mi_resource_group_name" {
  description = "The name of the Managed Identity resource group"
  value       = azurerm_resource_group.mi.name
}

output "mi_resource_group_id" {
  description = "The ID of the Managed Identity resource group"
  value       = azurerm_resource_group.mi.id
}

output "tfstate_resource_group_name" {
  description = "The name of the Terraform state resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "tfstate_resource_group_id" {
  description = "The ID of the Terraform state resource group"
  value       = azurerm_resource_group.tfstate.id
}

output "platform_resources_resource_group_name" {
  description = "The name of the platform resources resource group (if created)"
  value       = var.create_platform_resources_rg ? azurerm_resource_group.platform_resources[0].name : null
}

output "platform_resources_resource_group_id" {
  description = "The ID of the platform resources resource group (if created)"
  value       = var.create_platform_resources_rg ? azurerm_resource_group.platform_resources[0].id : null
}

