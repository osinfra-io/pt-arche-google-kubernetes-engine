# Google Service Account Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/service_account

data "google_service_account" "workload_identities" {
  for_each = var.namespaces

  account_id = var.workload_identity_service_account_emails[each.key]
}

# Kubernetes Namespace Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/namespace_v1

resource "kubernetes_namespace_v1" "gatekeeper-system" {
  metadata {
    labels = {
      "admission.gatekeeper.sh/ignore" = "no-self-managing"
      "istio-injection"                = "disabled"
    }

    name = "gatekeeper-system"
  }
}

# Kubernetes Role Binding Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/role_binding_v1

resource "kubernetes_role_binding_v1" "namespace_admins" {
  for_each = local.namespace_admin_service_accounts

  metadata {
    name      = "namespace-admin"
    namespace = kubernetes_namespace_v1.this[each.value.namespace].metadata.0.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "namespace-admin"
  }

  subject {
    kind = "User"
    name = each.value.service_account
  }
}

# Kubernetes Role Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/role_v1

resource "kubernetes_role_v1" "namespace_admins" {
  for_each = var.namespaces

  metadata {
    name      = "namespace-admin"
    namespace = kubernetes_namespace_v1.this[each.key].metadata.0.name
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
}

resource "kubernetes_namespace_v1" "this" {
  for_each = merge(
    var.namespaces,
    {
      "cert-manager"  = { istio_injection = "disabled" },
      "datadog"       = { istio_injection = "disabled" },
      "istio-ingress" = { istio_injection = "enabled" },
      "istio-system"  = { istio_injection = "disabled" }
      "istio-test"    = { istio_injection = "enabled" }
    }
  )

  metadata {
    labels = {
      "istio-injection" = each.value.istio_injection
    }

    name = each.key
  }
}

# Kubernetes Service Account Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/service_account_v1

resource "kubernetes_service_account_v1" "workload_identities" {
  for_each = var.namespaces

  metadata {

    annotations = {
      "iam.gke.io/gcp-service-account" = data.google_service_account.workload_identities[each.key].email
    }

    name      = "${each.key}-workload-identity-sa"
    namespace = kubernetes_namespace_v1.this[each.key].metadata.0.name
  }
}
