# Required Providers
# https://opentofu.org/docs/language/providers/requirements

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Remote State Data Source
# https://opentofu.org/docs/language/state/remote

data "terraform_remote_state" "main" {
  backend   = "gcs"
  workspace = "mock"

  config = {
    bucket = "mock"
  }
}

# Google Kubernetes Engine
# https://github.com/osinfra-io/pt-arche-google-kubernetes-engine

module "test" {
  source = "../../../../regional/onboarding"

  namespaces                               = var.namespaces
  project                                  = var.project
  workload_identity_service_account_emails = data.terraform_remote_state.main.outputs.workload_identity_service_account_emails
}
