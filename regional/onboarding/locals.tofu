# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  kubernetes_namespaces = {
    for name, namespace in local.namespaces_with_platform : name => {
      labels = namespace.mesh_enabled ? { "istio.io/dataplane-mode" = "ambient" } : {}
    }
  }

  namespaces_with_platform = merge(
    var.namespaces,
    {
      "cert-manager"  = { mesh_enabled = false },
      "datadog"       = { mesh_enabled = false },
      "istio-ingress" = { mesh_enabled = false },
      "istio-system"  = { mesh_enabled = false }
    }
  )

  workload_identity_service_account_names = {
    for name, namespace in var.namespaces : name => "${name}-workload-identity-sa"
  }
}
