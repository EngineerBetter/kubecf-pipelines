data "google_compute_network" "default" {
  name = "default"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = data.google_compute_network.default.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db.name]
}

resource "google_compute_global_address" "db" {
  provider      = google-beta
  name          = "db"
  address       = "10.4.0.0"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.self_link
}

resource "random_id" "db_name" {
  byte_length = 3
}

resource "google_sql_database_instance" "kubecf" {
  name             = "kubecf-${random_id.db_name.hex}"
  database_version = "MYSQL_5_7"
  region           = var.region

  deletion_protection = false

  settings {
    tier = "db-g1-small"

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.default.self_link
      require_ssl     = false
    }

    backup_configuration {
      enabled = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "uaa" {
  name     = "uaa"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "uaa" {
  length  = 16
  special = false
}

resource "google_sql_user" "uaa" {
  name     = "uaa"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.uaa.result
}

resource "google_sql_database" "cloud_controller" {
  name     = "cloud_controller"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "cloud_controller" {
  length  = 16
  special = false
}

resource "google_sql_user" "cloud_controller" {
  name     = "cloud_controller"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.cloud_controller.result
}

resource "google_sql_database" "diego" {
  name     = "diego"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "diego" {
  length  = 16
  special = false
}

resource "google_sql_user" "diego" {
  name     = "diego"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.diego.result
}

resource "google_sql_database" "api" {
  name     = "api"
  instance = google_sql_database_instance.kubecf.name
}

resource "google_sql_database" "routing_api" {
  name     = "routing_api"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "routing_api" {
  length  = 16
  special = false
}

resource "google_sql_user" "routing_api" {
  name     = "routing_api"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.routing_api.result
}

resource "google_sql_database" "network_policy" {
  name     = "network_policy"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "network_policy" {
  length  = 16
  special = false
}

resource "google_sql_user" "network_policy" {
  name     = "network_policy"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.network_policy.result
}

resource "google_sql_database" "network_connectivity" {
  name     = "network_connectivity"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "network_connectivity" {
  length  = 16
  special = false
}

resource "google_sql_user" "network_connectivity" {
  name     = "network_connectivity"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.network_connectivity.result
}

resource "google_sql_database" "locket" {
  name     = "locket"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "locket" {
  length  = 16
  special = false
}

resource "google_sql_user" "locket" {
  name     = "locket"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.locket.result
}

resource "google_sql_database" "credhub" {
  name     = "credhub"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "credhub" {
  length  = 16
  special = false
}

resource "google_sql_user" "credhub" {
  name     = "credhub"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.credhub.result
}

resource "google_sql_database" "autoscaler" {
  name     = "autoscaler"
  instance = google_sql_database_instance.kubecf.name
}

resource "random_password" "autoscaler" {
  length  = 16
  special = false
}

resource "google_sql_user" "autoscaler" {
  name     = "autoscaler"
  instance = google_sql_database_instance.kubecf.name
  password = random_password.autoscaler.result
}
