variable "billing_account_name" {
  description = "The name of the billing account."
  type        = string
}

variable "billing_profile_name" {
  description = "The name of the billing profile."
  type        = string
}

variable "invoice_section_name" {
  description = "The name of the invoice section."
  type        = string
}

variable "subscription_name" {
  description = "The name of the subscription to create."
  type        = string
}

variable "workload" {
  description = "The workload type of the Subscription. Possible values are Production (default) and DevTest."
  type        = string
  default     = "Production"
  validation {
    condition     = contains(["Production", "DevTest"], var.workload)
    error_message = "The workload must be either 'Production' or 'DevTest'."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the Subscription."
  type        = map(string)
  default     = {}
}
