# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  container_deployer_members = {
    for sa in local.container_deployer_service_accounts : sa => "serviceAccount:${sa}"
  }

  container_deployer_service_accounts = toset(distinct([
    for k in values(var.namespaces) : k.google_service_account
    if k.google_service_account != null
  ]))

  fleet_host_project_id     = local.is_fleet_host ? var.project : var.gke_fleet_host_project_id
  fleet_host_project_number = local.is_fleet_member ? data.google_project.this.number : ""

  gke_hub_service_agent_member = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-gkehub.iam.gserviceaccount.com"
  gke_mcs_importer_member      = "serviceAccount:${var.project}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  gke_mcs_service_agent_member = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-mcsd.iam.gserviceaccount.com"

  is_fleet_host   = var.gke_fleet_host_project_id == ""
  is_fleet_member = var.gke_fleet_host_project_id != ""

  workload_identities = {
    for k, v in var.namespaces : k => {
      account_id   = "gke-${random_id.this[k].hex}-workload-identity"
      display_name = "Kubernetes ${k} namespace workload identity service account"
      member       = "serviceAccount:${var.project}.svc.id.goog[${k}/${k}-workload-identity-sa]"
    }
  }

  workload_identity_service_account_emails = {
    for k, v in google_service_account.kubernetes_workload_identities : k => v.email
  }
}
