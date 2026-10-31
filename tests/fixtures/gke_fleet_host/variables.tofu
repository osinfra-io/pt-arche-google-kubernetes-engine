# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "namespaces" {
  description = "Map of Kubernetes namespaces and their configuration"

  type = map(object({
    google_service_account = string
    mesh_enabled           = optional(bool, false)
  }))
}

variable "project" {
  description = "The Google Cloud project ID"

  type = string
}
