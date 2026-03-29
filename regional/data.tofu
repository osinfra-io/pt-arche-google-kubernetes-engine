# Google Cloud Identity Group Lookup Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/cloud_identity_group_lookup

data "google_cloud_identity_group_lookup" "registry_readers" {
  group_key {
    id = "${var.cluster_prefix}-registry-readers@osinfra.io"
  }
}

# Google Container Engine Versions Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/container_engine_versions

data "google_container_engine_versions" "this" {
  location = module.core_helpers.region
  project  = var.project
}

# Google Project Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/project

data "google_project" "this" {
  project_id = var.project
}
