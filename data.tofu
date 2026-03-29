# Google Project Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/project#google_project

data "google_project" "this" {
  project_id = local.fleet_host_project_id
}
