# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "google_service_account" {
  type = string
}

variable "namespaces" {
  type = map(object({
    google_service_account = string
    istio_injection        = optional(string, "disabled")
  }))
}

variable "project" {
  type = string
}

variable "shared_vpc_host_project_id" {
  type = string
}
