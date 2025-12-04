module "subscription" {
  source              = "../../resources/subscription"
  subscription_name   = var.subscription_name
  alias               = var.subscription_name
  subscription_id     = var.subscription_id
  management_group_id = var.management_group_id
}
