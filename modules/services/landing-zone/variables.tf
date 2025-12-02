variable "prefix" {
  description = "Prefix for subscription naming (e.g., 'plb')"
  type        = string
}

variable "application" {
  description = "Application name/key for subscription naming (must be lowercase)"
  type        = string
  validation {
    condition     = var.application == lower(var.application)
    error_message = "Application must be lowercase. Provided value: '${var.application}'"
  }
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "sequence" {
  description = "Sequence number for naming (must be 3 characters)"
  type        = string
  validation {
    condition     = length(var.sequence) == 3
    error_message = "Sequence must be exactly 3 characters long."
  }
}

variable "billing_account_name" {
  description = "The name of the billing account"
  type        = string
}

variable "billing_profile_name" {
  description = "The name of the billing profile"
  type        = string
}

variable "invoice_section_name" {
  description = "The name of the invoice section"
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