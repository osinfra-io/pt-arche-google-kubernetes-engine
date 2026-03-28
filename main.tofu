# Google Project Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/project#google_project

data "google_project" "this" {
  project_id = local.fleet_host_project_id
}

# Google Project IAM Member Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member

resource "google_project_iam_member" "container_deployers" {
  for_each = local.container_deployer_service_accounts

  member  = "serviceAccount:${each.value}"
  project = var.project
  role    = "organizations/163313809793/roles/container.deployer"
}

# This section provides an example MCS configuration involving two existing GKE clusters each in a different Shared VPC service project.
# https://cloud.google.com/kubernetes-engine/docs/how-to/msc-setup-with-shared-vpc-networks#two-service-projects-iam

# Create IAM binding granting the fleet host project's GKE Hub service account the GKE Service Agent role on the service cluster's project.

resource "google_project_iam_member" "gke_hub_service_agent" {
  lifecycle {
    enabled = !local.is_fleet_host
  }

  member  = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-gkehub.iam.gserviceaccount.com"
  project = var.project
  role    = "roles/gkehub.serviceAgent"
}

# Create IAM binding granting the fleet host project's MCS service account the MCS Service Agent role on the service cluster's project.

resource "google_project_iam_member" "gke_mcs_service_agent" {
  member  = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-mcsd.iam.gserviceaccount.com"
  project = var.project
  role    = "roles/multiclusterservicediscovery.serviceAgent"
}

# Create IAM binding granting each project's MCS service account the Network User role for its own project.
# Because this scenario uses workload identity federation for GKE, each project's MCS Importer GKE service
# account needs the Network User role for its own project.

# These resources needs a clusters created first, so new infrastructure builds will fail on the global run.
# As a W/A run the regional infrastructure first and then the global infrastructure.

resource "google_project_iam_member" "host_project_network_viewer" {
  lifecycle {
    enabled = !local.is_fleet_host
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

resource "google_project_iam_member" "service_project_network_viewer" {
  lifecycle {
    enabled = local.is_fleet_host
  }

  member  = "serviceAccount:${var.project}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  project = var.project
  role    = "roles/compute.networkViewer"
}

# Random ID Resource
# https://search.opentofu.org/provider/hashicorp/random/latest/docs/resources/id

resource "random_id" "this" {
  for_each = var.namespaces

  byte_length = 3
  prefix      = "tf"
}

# Google Service Account IAM Member Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_service_account_iam#google_service_account_iam_member

resource "google_service_account_iam_member" "workload_identities" {
  for_each = var.namespaces

  member             = "serviceAccount:${var.project}.svc.id.goog[${each.key}/${each.key}-workload-identity-sa]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.kubernetes_workload_identities[each.key].name
}
