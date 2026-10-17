# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "namespaces" {
  description = "Map of Kubernetes namespaces and their configuration"

  type = map(any)
}
