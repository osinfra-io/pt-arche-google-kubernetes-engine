# Local Values
# https://opentofu.org/docs/language/values/locals

locals {

  # To provide a simple interface for cluster autoscaling, we use this local to provide
  # clarity to the user on what resources are available for autoscaling. You can only have a
  # single resource type of cpu and memory.

  autoscaling_resource_limits = var.cluster_autoscaling.enabled ? [
    {
      maximum       = var.cluster_autoscaling.resource_limits_max_cpu_cores
      minimum       = var.cluster_autoscaling.resource_limits_min_cpu_cores
      resource_type = "cpu"
    },
    {
      maximum       = var.cluster_autoscaling.resource_limits_max_memory_gb
      minimum       = var.cluster_autoscaling.resource_limits_min_memory_gb
      resource_type = "memory"
    }
  ] : []

  cluster_autoscaling_auto_provisioning_defaults = var.cluster_autoscaling.enabled ? [var.cluster_autoscaling.enabled] : []

  cluster_autoscaling_blue_green_settings = var.cluster_autoscaling.upgrade_settings_strategy == "BLUE_GREEN" ? [var.cluster_autoscaling.upgrade_settings_strategy] : []

  cluster_autoscaling_max_surge = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" ? var.cluster_autoscaling.upgrade_settings_max_surge : null

  cluster_autoscaling_max_unavailable = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" ? var.cluster_autoscaling.upgrade_settings_max_unavailable : null

  cluster_autoscaling_upgrade_settings = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" || var.cluster_autoscaling.upgrade_settings_strategy == "BLUE_GREEN" ? [var.cluster_autoscaling.upgrade_settings_strategy] : []

  default_node_account_id   = "gke-${random_id.this.hex}"
  default_node_display_name = "Kubernetes minimum privilege service account for: ${local.name}"
  default_node_member       = "serviceAccount:${google_service_account.default_node.email}"

  enabled_gke_hub_memberships = var.enable_gke_hub_host ? var.gke_hub_memberships : {}

  gateway_api_configs = var.enable_gateway_api ? [1] : []

  gke_hub_memberships = {
    for k, v in local.enabled_gke_hub_memberships : k => {
      cluster_id = v.cluster_id
      issuer     = "https://container.googleapis.com/v1/${v.cluster_id}"
    }
  }

  key_ring_name = "${local.name}-cluster-encryption-${random_id.this.hex}"

  kms_crypto_keys = {
    cluster-boot-disk-encryption = {

      # For CMEK-protected node boot disks and CMEK-protected attached disks, this Compute Engine service account is the account
      # which requires permissions to do encryption using your Cloud KMS key. This is true even if you are using a custom service
      # account on your nodes.

      crypto_key_name = "cluster-boot-disk-encryption-${random_id.this.hex}"
      service_account = "serviceAccount:service-${data.google_project.this.number}@compute-system.iam.gserviceaccount.com"
    }

    cluster-database-encryption = {
      crypto_key_name = "cluster-database-encryption-${random_id.this.hex}"
      service_account = "serviceAccount:service-${data.google_project.this.number}@container-engine-robot.iam.gserviceaccount.com"
    }
  }

  name           = module.core_helpers.zone == null ? "${var.cluster_prefix}-${module.core_helpers.region}" : "${var.cluster_prefix}-${module.core_helpers.region}-${module.core_helpers.zone}"
  network        = "projects/${var.vpc_host_project_id}/global/networks/${var.network}"
  node_locations = module.core_helpers.zone != null ? ["${module.core_helpers.region}-${module.core_helpers.zone}"] : null

  private_endpoint_subnetwork = "projects/${var.vpc_host_project_id}/regions/${module.core_helpers.region}/subnetworks/${var.private_endpoint_subnetwork}"

  subnet = "projects/${var.vpc_host_project_id}/regions/${module.core_helpers.region}/subnetworks/${var.subnet}"

  workload_pool = "${var.project}.svc.id.goog"
}
