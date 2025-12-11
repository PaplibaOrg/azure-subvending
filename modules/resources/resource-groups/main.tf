resource "azurerm_resource_group" "mi" {
  name     = "rg-${var.subscription_name}-mi"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-${var.subscription_name}-tfstate"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "platform_resources" {
  count    = var.create_platform_resources_rg ? 1 : 0
  name     = "rg-${var.subscription_name}-platform-resources"
  location = var.location
  tags     = var.tags
}

