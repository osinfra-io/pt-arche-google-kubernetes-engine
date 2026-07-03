# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  namespace_admin_service_accounts = {
    for k, v in var.namespaces : "${k}:${v.google_service_account}" => {
      namespace       = k,
      service_account = v.google_service_account
    }
    if v.google_service_account != null
  }
}
