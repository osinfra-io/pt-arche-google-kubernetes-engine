# Moved Blocks
# https://opentofu.org/docs/language/moved

moved {
  from = kubernetes_role_binding_v1.namespace_admin
  to   = kubernetes_role_binding_v1.namespace_admins
}

moved {
  from = kubernetes_role_v1.namespace_admin
  to   = kubernetes_role_v1.namespace_admins
}

moved {
  from = kubernetes_service_account_v1.workload_identity
  to   = kubernetes_service_account_v1.workload_identities
}

moved {
  from = module.helpers
  to   = module.core_helpers
}
