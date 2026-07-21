# Local Values
# https://opentofu.org/docs/language/values/locals
#
# Merges the team namespaces with the platform-internal namespaces this module
# always manages, and computes the label map for each namespace. The
# osinfra.io/route-prefix label is only applied to team namespaces that set it.

locals {
  # Platform-internal namespaces managed by this module. These never carry a
  # team route prefix.
  internal_namespaces = {
    "cert-manager"  = { istio_injection = "disabled", route_prefix = null }
    "datadog"       = { istio_injection = "disabled", route_prefix = null }
    "istio-ingress" = { istio_injection = "enabled", route_prefix = null }
    "istio-system"  = { istio_injection = "disabled", route_prefix = null }
  }

  # Team namespaces normalized to the fields used for namespace creation.
  team_namespaces = {
    for name, namespace in var.namespaces : name => {
      istio_injection = namespace.istio_injection
      route_prefix    = namespace.route_prefix
    }
  }

  namespaces = merge(local.team_namespaces, local.internal_namespaces)

  # Labels per namespace: istio-injection is always set; osinfra.io/route-prefix
  # is added only when the namespace declares a route prefix.
  namespace_labels = {
    for name, namespace in local.namespaces : name => merge(
      {
        "istio-injection" = namespace.istio_injection
      },
      namespace.route_prefix == null ? {} : {
        "osinfra.io/route-prefix" = namespace.route_prefix
      }
    )
  }
}
