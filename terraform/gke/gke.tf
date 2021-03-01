resource "google_container_cluster" "kubecf" {
  provider = google-beta

  name     = "kubecf"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  ip_allocation_policy {}

  master_auth {
    username = "admin"
    password = random_password.cluster_admin_password.result

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "nodes" {
  name               = "my-node-pool"
  location           = var.region
  cluster            = google_container_cluster.kubecf.name
  initial_node_count = 1

  autoscaling {
    min_node_count = var.node_counts_per_zone.min
    max_node_count = var.node_counts_per_zone.max
  }

  node_config {
    image_type   = "ubuntu_containerd"
    preemptible  = false
    machine_type = "n1-highmem-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "random_password" "cluster_admin_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}
