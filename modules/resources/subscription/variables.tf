variable "subscription_name" {
  description = "The display name of the subscription"
  type        = string
}

variable "subscription_id" {
  description = "The ID of the existing subscription to create an alias for. Optional - will be looked up from subscription_name if not provided."
  type        = string
  default     = null
}

variable "alias" {
  description = "The alias name for the subscription"
  type        = string
}

variable "management_group_id" {
  description = "The management group ID where the subscription should be placed"
  type        = string
}