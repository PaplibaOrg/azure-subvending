variable "alias" {
  description = "The alias name for the subscription"
  type        = string
}

variable "subscription_id" {
  description = "The ID of the existing subscription to create an alias for (optional, will be looked up by name if not provided)"
  type        = string
  default     = null
}

variable "subscription_name" {
  description = "The display name of the subscription"
  type        = string
}
