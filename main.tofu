# Google GKE Hub Feature
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/gke_hub_feature

resource "google_gke_hub_feature" "multi_cluster_service_discovery" {
  lifecycle {
    enabled = local.is_fleet_host
  }

  labels   = var.labels
  location = "global"
  name     = "multiclusterservicediscovery"
  project  = var.project
}

# Google Project IAM Member Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member

resource "google_project_iam_member" "container_deployers" {
  for_each = local.container_deployer_service_accounts

  member  = "serviceAccount:${each.value}"
  project = var.project
  role    = "organizations/163313809793/roles/container.deployer"
}

resource "google_project_iam_member" "gke_hub_service_agent" {
  lifecycle {
    enabled = !local.is_fleet_host
  }

  member  = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-gkehub.iam.gserviceaccount.com"
  project = var.project
  role    = "roles/gkehub.serviceAgent"
}

resource "google_project_iam_member" "gke_mcs_service_agent" {
  member  = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-mcsd.iam.gserviceaccount.com"
  project = var.project
  role    = "roles/multiclusterservicediscovery.serviceAgent"
}

resource "google_project_iam_member" "host_project_network_viewer" {
  lifecycle {
    enabled = !local.is_fleet_host
  }

  member  = "serviceAccount:${var.project}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  project = var.project
  role    = "roles/compute.networkViewer"
}

resource "google_project_iam_member" "service_project_network_viewer" {
  lifecycle {
    enabled = local.is_fleet_host
  }

  member  = "serviceAccount:${var.project}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  project = var.project
  role    = "roles/compute.networkViewer"
}

# Google Service Account Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_service_account

resource "google_service_account" "kubernetes_workload_identities" {
  for_each = var.namespaces

  account_id   = "gke-${random_id.this[each.key].hex}-workload-identity"
  display_name = "Kubernetes ${each.key} namespace workload identity service account"
  project      = var.project
}

# Google Service Account IAM Member Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_service_account_iam#google_service_account_iam_member

resource "google_service_account_iam_member" "workload_identities" {
  for_each = var.namespaces

  member             = "serviceAccount:${var.project}.svc.id.goog[${each.key}/${each.key}-workload-identity-sa]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.kubernetes_workload_identities[each.key].name
}

# Random ID Resource
# https://search.opentofu.org/provider/hashicorp/random/latest/docs/resources/id

resource "random_id" "this" {
  for_each = var.namespaces

  byte_length = 3
  prefix      = "tf"
}
