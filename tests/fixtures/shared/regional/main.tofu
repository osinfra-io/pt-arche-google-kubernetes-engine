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
  source = "../../../../regional"

  cluster_prefix             = "mock"
  enable_deletion_protection = false
  enable_gke_hub_host        = var.enable_gke_hub_host
  gke_hub_memberships        = var.gke_hub_memberships

  labels = {
    "mock-key" = "mock-value"
  }

  network                     = "mock-network"
  node_pools                  = var.node_pools
  private_endpoint_subnetwork = "mock-master-subnet"
  project                     = var.project

  resource_labels = {
    region = "mock-region"
  }

  subnet              = "mock-subnet"
  vpc_host_project_id = var.vpc_host_project_id
}
