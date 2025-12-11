variable "subscription_name" {
  description = "The subscription name used for resource group naming"
  type        = string
}

variable "location" {
  description = "The Azure region where the resource groups will be created"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A map of tags to assign to the resource groups"
  type        = map(string)
  default     = {}
}

variable "create_platform_resources_rg" {
  description = "Whether to create the platform-resources resource group"
  type        = bool
  default     = false
}

