# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "namespaces" {
  default     = {}
  description = "A map of namespaces with an optional Google service account used for the namespace administrator and whether Istio injection is enabled or disabled. When google_service_account is null, the namespace-admin Role and RoleBinding are skipped."

  type = map(object({
    annotations                  = optional(map(string))
    google_service_account       = optional(string, null)
    istio_control_plane_clusters = optional(string)
    istio_injection              = optional(string, "disabled")
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
