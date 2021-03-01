
output "db_ca_cert_pem" { value = google_sql_database_instance.kubecf.server_ca_cert.0.cert }
output "db_port" { value = 3306 }
output "db_host" { value = google_sql_database_instance.kubecf.private_ip_address }

output "db_uaa_name" { value = google_sql_database.uaa.name }
output "db_uaa_username" { value = google_sql_user.uaa.name }
output "db_uaa_password" {
  value     = google_sql_user.uaa.password
  sensitive = true
}

output "db_cloud_controller_name" { value = google_sql_database.cloud_controller.name }
output "db_cloud_controller_username" { value = google_sql_user.cloud_controller.name }
output "db_cloud_controller_password" {
  value     = google_sql_user.cloud_controller.password
  sensitive = true
}

output "db_diego_name" { value = google_sql_database.diego.name }
output "db_diego_username" { value = google_sql_user.diego.name }
output "db_diego_password" {
  value     = google_sql_user.diego.password
  sensitive = true
}

output "db_routing_api_name" { value = google_sql_database.routing_api.name }
output "db_routing_api_username" { value = google_sql_user.routing_api.name }
output "db_routing_api_password" {
  value     = google_sql_user.routing_api.password
  sensitive = true
}

output "db_network_policy_name" { value = google_sql_database.network_policy.name }
output "db_network_policy_username" { value = google_sql_user.network_policy.name }
output "db_network_policy_password" {
  value     = google_sql_user.network_policy.password
  sensitive = true
}

output "db_network_connectivity_name" { value = google_sql_database.network_connectivity.name }
output "db_network_connectivity_username" { value = google_sql_user.network_connectivity.name }
output "db_network_connectivity_password" {
  value     = google_sql_user.network_connectivity.password
  sensitive = true
}

output "db_locket_name" { value = google_sql_database.locket.name }
output "db_locket_username" { value = google_sql_user.locket.name }
output "db_locket_password" {
  value     = google_sql_user.locket.password
  sensitive = true
}

output "db_credhub_name" { value = google_sql_database.credhub.name }
output "db_credhub_username" { value = google_sql_user.credhub.name }
output "db_credhub_password" {
  value     = google_sql_user.credhub.password
  sensitive = true
}

output "db_autoscaler_name" { value = google_sql_database.autoscaler.name }
output "db_autoscaler_username" { value = google_sql_user.autoscaler.name }
output "db_autoscaler_password" {
  value     = google_sql_user.autoscaler.password
  sensitive = true
}

output "gorouter_static_ip" {
  value = google_compute_address.gorouter_static_ip.address
}

output "ssh_proxy_static_ip" {
  value = google_compute_address.ssh_proxy_static_ip.address
}

output "wildcard_cert" {
  sensitive = true
  value = {
    private_key = acme_certificate.wildcard.private_key_pem
    chain       = <<-EOCERT
    ${acme_certificate.wildcard.certificate_pem}
    ${acme_certificate.wildcard.issuer_pem}
    EOCERT
    certificate = acme_certificate.wildcard.certificate_pem
    ca          = acme_certificate.wildcard.issuer_pem
  }
}
