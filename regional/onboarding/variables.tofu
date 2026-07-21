# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "namespaces" {
  default     = {}
  description = "A map of namespaces with the Google service account bound as the namespace administrator and whether Istio injection is enabled or disabled. A namespace-admin Role and RoleBinding are always created for the service account. When route_prefix is set, the osinfra.io/route-prefix label is applied so the namespace can attach HTTPRoutes to its team's shared gateway listener."

  type = map(object({
    annotations                  = optional(map(string))
    google_service_account       = string
    istio_control_plane_clusters = optional(string)
    istio_injection              = optional(string, "disabled")
    route_prefix                 = optional(string)
  }))
}

variable "project" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "workload_identity_service_account_emails" {
  description = "A map of workload identity service account emails for each namespace. Each key should be a namespace name, and the value should be the email address of the service account to associate with that namespace."
  type        = map(string)
}
