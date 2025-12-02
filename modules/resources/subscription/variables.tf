variable "subscription_name" {
  description = "The display name of the subscription"
  type        = string
}

variable "billing_scope_id" {
  description = "The billing scope ID (e.g., /providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName})"
  type        = string
}

variable "management_group_id" {
  description = "The management group ID where the subscription should be placed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the subscription"
  type        = map(string)
  default     = {}
}
