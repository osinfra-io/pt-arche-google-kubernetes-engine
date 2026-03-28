# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "gke_fleet_host_project_id" {
  description = "The project ID of the GKE fleet host project"

  type = string
}

variable "google_service_account" {
  description = "The Google service account email"

  type = string
}

variable "namespaces" {
  description = "Map of Kubernetes namespaces and their configuration"

  type = map(object({
    google_service_account = string
    istio_injection        = optional(string, "disabled")
  }))
}

variable "project" {
  description = "The Google Cloud project ID"

  type = string
}

variable "shared_vpc_host_project_id" {
  description = "The project ID of the shared VPC host project"

  type = string
}
