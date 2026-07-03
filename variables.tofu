# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "gke_fleet_host_project_id" {
  default     = ""
  description = "The project ID of the GKE Hub host project"
  type        = string
}

variable "labels" {
  default     = {}
  description = "A map of key/value pairs to assign to the resources being created"
  type        = map(string)
}

variable "namespaces" {
  default     = {}
  description = "A map of namespaces with an optional Google service account used for the namespace administrator and whether Istio injection is enabled or disabled"
  type = map(object({
    google_service_account = optional(string, null)
    istio_injection        = optional(string, "disabled")
  }))
}

variable "project" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}
