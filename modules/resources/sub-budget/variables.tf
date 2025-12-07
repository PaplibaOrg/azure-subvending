variable "budget_name" {
  description = "The name of the consumption budget"
  type        = string
}

variable "subscription_id" {
  description = "The ID of the subscription for the budget (in /subscriptions/{uuid} format)"
  type        = string
}

variable "amount" {
  description = "The amount of the budget"
  type        = number
}

variable "time_grain" {
  description = "The time grain for the budget (Monthly, Quarterly, Annually)"
  type        = string
  default     = "Monthly"
}

variable "start_date" {
  description = "The start date for the budget in YYYY-MM-DD format"
  type        = string
}

variable "end_date" {
  description = "The end date for the budget in YYYY-MM-DD format. Use '2099-12-31' for no end date"
  type        = string
  default     = "2099-12-31"
}

variable "notifications" {
  description = "List of notification configurations for the budget"
  type = list(object({
    enabled        = bool
    threshold      = number
    operator       = string
    threshold_type = string
    contact_emails = list(string)
  }))
  default = []
}

