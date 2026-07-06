# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "cluster_autoscaling" {
  default     = {}
  description = "Per-cluster configuration of node auto-provisioning with cluster autoscaler to automatically adjust the size of the cluster and create/delete node pools based on the current needs of the cluster's workload"
  type = object({
    autoscaling_profile                      = optional(string, "OPTIMIZE_UTILIZATION")
    disk_type                                = optional(string)
    enabled                                  = optional(bool, false)
    image_type                               = optional(string)
    oauth_scopes                             = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    resource_limits_max_cpu_cores            = optional(number, 6)
    resource_limits_max_memory_gb            = optional(number, 32)
    resource_limits_min_cpu_cores            = optional(number, 0)
    resource_limits_min_memory_gb            = optional(number, 0)
    upgrade_settings_batch_node_count        = optional(number)
    upgrade_settings_batch_percentage        = optional(number)
    upgrade_settings_batch_soak_duration     = optional(string)
    upgrade_settings_max_surge               = optional(number)
    upgrade_settings_max_unavailable         = optional(number, 1) # https://github.com/hashicorp/terraform-provider-google/issues/17164
    upgrade_settings_node_pool_soak_duration = optional(string)
    upgrade_settings_strategy                = optional(string, "SURGE")
  })
}

variable "cluster_prefix" {
  description = "Prefix for your cluster name, region, and zone (if applicable) will be added to the end of the cluster name. Must be 20 characters or less"
  type        = string
  validation {
    condition     = length(var.cluster_prefix) <= 20
    error_message = "The cluster prefix must be 20 characters or less."
  }
}

variable "daily_maintenance_window" {
  default     = "06:00"
  description = "Time window specified for daily maintenance operations"
  type        = string
}

variable "enable_deletion_protection" {
  default     = true
  description = "Whether or not to enable deletion protection on the cluster"
  type        = bool
}

variable "enable_gateway_api" {
  default     = false
  description = "Whether or not to enable the Kubernetes Gateway API on the cluster"
  type        = bool
}

variable "enable_gke_hub_host" {
  default     = false
  description = "Whether or not to enable GKE Hub Host"
  type        = bool
}

variable "gke_hub_memberships" {
  default     = {}
  description = "The map of GKE Hub Memberships to create"
  type = map(object({
    cluster_id = string
  }))
}

variable "labels" {
  default     = {}
  description = "A map of key/value pairs to assign to the resources being created"
  type        = map(string)
}

variable "network" {
  default     = "standard-shared"
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected"
  type        = string
}

variable "node_pools" {
  default     = {}
  description = "The node pools to create in the cluster"
  type = map(object({
    auto_repair                              = optional(bool)
    auto_upgrade                             = optional(bool)
    disk_size_gb                             = optional(number)
    disk_type                                = optional(string)
    image_type                               = optional(string)
    machine_type                             = optional(string)
    max_node_count                           = optional(number, 3)
    min_node_count                           = optional(number, 0)
    node_count                               = optional(number)
    oauth_scopes                             = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    upgrade_settings_batch_node_count        = optional(number)
    upgrade_settings_batch_percentage        = optional(number)
    upgrade_settings_batch_soak_duration     = optional(string)
    upgrade_settings_max_surge               = optional(number)
    upgrade_settings_max_unavailable         = optional(number, 1) # https://github.com/hashicorp/terraform-provider-google/issues/17164
    upgrade_settings_node_pool_soak_duration = optional(string)
    upgrade_settings_strategy                = optional(string, "SURGE")
  }))
}

variable "private_endpoint_subnetwork" {
  description = "The name of the subnetwork in which the cluster's master endpoint will be created"
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "release_channel" {
  default     = "REGULAR"
  description = "Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters"
  type        = string
}

variable "resource_labels" {
  default     = {}
  description = "The GCP labels (key/value pairs) to be applied to each node"
  type        = map(string)
}

variable "subnet" {
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched"
  type        = string
}

variable "vpc_host_project_id" {
  description = "Host project for the shared VPC"
  type        = string
}
