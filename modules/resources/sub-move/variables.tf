variable "management_group_id" {
  description = "The management group ID where the subscription should be moved to"
  type        = string
}

variable "subscription_id" {
  description = "The ID of the subscription to move (in /subscriptions/{uuid} format)"
  type        = string
}
