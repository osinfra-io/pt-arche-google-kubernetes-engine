# Required Providers
# https://opentofu.org/docs/language/providers/requirements

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

# Google Kubernetes Engine
# https://github.com/osinfra-io/pt-arche-google-kubernetes-engine

module "test" {
  source = "../../../"

  gke_fleet_host_project_id = var.gke_fleet_host_project_id

  labels = {
    "mock-key" = "mock-value"
  }

  namespaces = var.namespaces
  project    = var.project
}
