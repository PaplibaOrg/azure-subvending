variable "application" {
  description = "Application name/key for subscription naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "sequence" {
  description = "Sequence number for naming"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "billing_scope_id" {
  description = "The billing scope ID for the subscription"
  type        = string
}

variable "management_group_id" {
  description = "The management group ID where the subscription should be placed"
  type        = string
}

variable "tags" {
  description = "Base tags object"
  type = object({
    owner       = string
    application = string
    costCenter  = optional(string)
    project     = optional(string)
  })
}


