variable "management_group_id" {
  description = "The management group ID where the subscription should be moved to"
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

variable "tags" {
  description = "A map of tags to assign to the subscription"
  type        = map(string)
  default     = {}
}
