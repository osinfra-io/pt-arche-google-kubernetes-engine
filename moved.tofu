# Moved Blocks
# https://opentofu.org/docs/language/moved

moved {
  from = google_project_iam_member.container_deployer
  to   = google_project_iam_member.container_deployers
}

moved {
  from = google_service_account.kubernetes_workload_identity
  to   = google_service_account.kubernetes_workload_identities
}

moved {
  from = google_service_account_iam_member.workload_identity
  to   = google_service_account_iam_member.workload_identities
}
