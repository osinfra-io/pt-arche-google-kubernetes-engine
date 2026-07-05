# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  container_deployer_service_accounts = toset(distinct([
    for k in values(var.namespaces) : k.google_service_account
    if k.google_service_account != null
  ]))

  fleet_host_project_id     = local.is_fleet_host ? var.project : var.gke_fleet_host_project_id
  fleet_host_project_number = var.gke_fleet_host_project_id != "" ? data.google_project.this.number : ""

  is_fleet_host = var.gke_fleet_host_project_id == ""
}
