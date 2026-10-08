mock_provider "google" {
  mock_resource "google_service_account" {
    defaults = {
      name  = "projects/mock/serviceAccounts/mock-github@mock.iam.gserviceaccount.com"
      email = "mock-github@mock.iam.gserviceaccount.com"
    }
  }
}

mock_provider "kubernetes" {}

mock_provider "terraform" {
  mock_data "terraform_remote_state" {
    defaults = {
      outputs = {
        workload_identity_service_account_emails = {
          namespace-a = "mock-a-workload-identity@mock.iam.gserviceaccount.com"
          namespace-b = "mock-b-workload-identity@mock.iam.gserviceaccount.com"
        }
      }
    }
  }
}

run "gke_fleet_host" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_host"
  }

  variables {
    project                    = "mock-project-host-project"
    shared_vpc_host_project_id = "mock-vpc-host-project"
  }
}

run "gke_fleet_host_regional" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_host/regional"
  }

  variables {
    enable_gke_hub_host = true

    gke_hub_memberships = {
      "mock-fleet-member" = {
        cluster_id = "projects/mock/locations/mock-region/clusters/mock-fleet-member"
      }
    }

    node_pools = {
      default-pool = {
        machine_type   = "e2-standard-2"
        max_node_count = 1
        min_node_count = 0
      }
    }

    project             = "mock-project-host-project"
    vpc_host_project_id = "mock-vpc-host-project"
  }
}

run "node_pool_surge_settings" {
  command = plan

  module {
    source = "./regional"
  }

  variables {
    cluster_prefix = "mock"
    node_pools = {
      default-pool = {
        machine_type                     = "e2-standard-2"
        max_node_count                   = 1
        min_node_count                   = 0
        node_count                       = 1
        upgrade_settings_max_surge       = 2
        upgrade_settings_max_unavailable = 3
      }
    }
    private_endpoint_subnetwork = "mock-master-subnet"
    project                     = "mock-project"
    subnet                      = "mock-subnet"
    vpc_host_project_id         = "mock-vpc-host-project"
  }

  assert {
    condition     = google_container_node_pool.this["default-pool"].upgrade_settings[0].max_surge == 2
    error_message = "The node pool max_surge input must be applied"
  }

  assert {
    condition     = google_container_node_pool.this["default-pool"].upgrade_settings[0].max_unavailable == 3
    error_message = "The node pool max_unavailable input must be applied"
  }

  assert {
    condition     = google_container_node_pool.this["default-pool"].management[0].auto_repair
    error_message = "Node pool auto-repair must remain enabled"
  }

  assert {
    condition     = google_container_node_pool.this["default-pool"].management[0].auto_upgrade
    error_message = "Node pool auto-upgrade must remain enabled"
  }
}

run "gke_fleet_host_regional_onboarding" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_host/regional_onboarding"
  }

  variables {
    project = "mock-project-host-project"
  }
}


run "gke_fleet_member" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_member"
  }

  variables {
    gke_fleet_host_project_id  = "mock-fleet-host-project"
    project                    = "mock-project-member-project"
    shared_vpc_host_project_id = "mock-vpc-host-project"
  }
}

run "gke_fleet_member_regional" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_member/regional"
  }

  variables {
    enable_gke_hub_host = false

    gke_hub_memberships = {}

    node_pools = {
      default-pool = {
        machine_type   = "e2-standard-2"
        max_node_count = 1
        min_node_count = 0
      }
    }

    project             = "mock-project-member-project"
    vpc_host_project_id = "mock-vpc-host-project"
  }
}

run "gke_fleet_member_regional_onboarding" {
  command = apply

  module {
    source = "./tests/fixtures/gke_fleet_member/regional_onboarding"
  }

  variables {
    project = "mock-project-member-project"
  }
}

variables {
  google_service_account = "mock@mock.iam.gserviceaccount.com"

  namespaces = {
    namespace-a = {
      google_service_account = "mock-github@mock.gserviceaccount.com"
      mesh_enabled           = true
    }
    namespace-b = {
      google_service_account = "mock-github@mock.gserviceaccount.com"
    }
  }

  master_ipv4_cidr_block = "192.0.2.0/28" # https://www.rfc-editor.org/rfc/rfc5737#section-3
}
