# Local Values
# https://opentofu.org/docs/language/values/locals

locals {

  # To provide a simple interface for cluster autoscaling, we use this local to provide
  # clarity to the user on what resources are available for autoscaling. You can only have a
  # single resource type of cpu and memory.

  cluster_autoscaling_auto_provisioning_defaults = var.cluster_autoscaling.enabled ? [var.cluster_autoscaling.enabled] : []

  cluster_autoscaling_blue_green_settings = var.cluster_autoscaling.upgrade_settings_strategy == "BLUE_GREEN" ? [var.cluster_autoscaling.upgrade_settings_strategy] : []

  cluster_autoscaling_max_surge = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" ? var.cluster_autoscaling.upgrade_settings_max_surge : null

  cluster_autoscaling_max_unavailable = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" ? var.cluster_autoscaling.upgrade_settings_max_unavailable : null

  cluster_autoscaling_upgrade_settings = var.cluster_autoscaling.upgrade_settings_strategy == "SURGE" || var.cluster_autoscaling.upgrade_settings_strategy == "BLUE_GREEN" ? [var.cluster_autoscaling.upgrade_settings_strategy] : []

  autoscaling_resource_limits = var.cluster_autoscaling.enabled ? [
    {
      resource_type = "cpu"
      minimum       = var.cluster_autoscaling.resource_limits_min_cpu_cores
      maximum       = var.cluster_autoscaling.resource_limits_max_cpu_cores
    },
    {
      resource_type = "memory"
      minimum       = var.cluster_autoscaling.resource_limits_min_memory_gb
      maximum       = var.cluster_autoscaling.resource_limits_max_memory_gb
    }
  ] : []

  gke_hub_memberships = var.enable_gke_hub_host ? var.gke_hub_memberships : {}

  kms_crypto_keys = {
    cluster-boot-disk-encryption = {

      # For CMEK-protected node boot disks and CMEK-protected attached disks, this Compute Engine service account is the account
      # which requires permissions to do encryption using your Cloud KMS key. This is true even if you are using a custom service
      # account on your nodes.

      service_account = "serviceAccount:service-${data.google_project.this.number}@compute-system.iam.gserviceaccount.com"
    }

    cluster-database-encryption = {
      service_account = "serviceAccount:service-${data.google_project.this.number}@container-engine-robot.iam.gserviceaccount.com"
    }
  }

  name           = module.helpers.zone == null ? "${var.cluster_prefix}-${module.helpers.region}" : "${var.cluster_prefix}-${module.helpers.region}-${module.helpers.zone}"
  network        = "projects/${var.vpc_host_project_id}/global/networks/${var.network}"
  node_locations = module.helpers.zone != null ? ["${module.helpers.region}-${module.helpers.zone}"] : null
  subnet         = "projects/${var.vpc_host_project_id}/regions/${module.helpers.region}/subnetworks/${var.subnet}"
}
