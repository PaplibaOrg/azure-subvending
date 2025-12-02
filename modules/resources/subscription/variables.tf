variable "subscription_name" {
  description = "The display name of the subscription"
  type        = string
}

variable "billing_account_name" {
  description = "The name of the billing account (e.g., e879cf0f-2b4d-5431-109a-f72fc9868693:024cabf4-7321-4cf9-be59-df0c77ca51de_2019-05-31)"
  type        = string
}

variable "billing_profile_name" {
  description = "The name of the billing profile (e.g., PE2Q-NOIT-BG7-TGB)"
  type        = string
}

variable "invoice_section_name" {
  description = "The name of the invoice section (e.g., MTT4-OBS7-PJA-TGB)"
  type        = string
}

variable "management_group_id" {
  description = "The management group ID where the subscription should be placed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the subscription"
  type        = map(string)
}

variable "workload" {
  description = "The workload type of the subscription. Must be either 'Production' or 'DevTest'"
  type        = string
  validation {
    condition     = contains(["Production", "DevTest"], var.workload)
    error_message = "Workload must be either 'Production' or 'DevTest'."
  }
}