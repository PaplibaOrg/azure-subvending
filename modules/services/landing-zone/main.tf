module "subscription" {
  source            = "../../resources/sub-alias-create"
  alias             = var.subscription_name
  subscription_id   = var.subscription_id
  subscription_name = var.subscription_name
}

module "sub_move" {
  source              = "../../resources/sub-move"
  management_group_id = var.management_group_id
  subscription_id     = "/subscriptions/${var.subscription_id}"
}
