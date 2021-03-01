data "google_dns_managed_zone" "kubecf" {
  name = var.dns_zone_name
}

resource "google_dns_record_set" "wildcard" {
  name = "*.${data.google_dns_managed_zone.kubecf.dns_name}"

  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.kubecf.name

  rrdatas = [google_compute_address.gorouter_static_ip.address]
}

resource "google_dns_record_set" "ssh" {
  name = "ssh.${data.google_dns_managed_zone.kubecf.dns_name}"

  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.kubecf.name

  rrdatas = [google_compute_address.ssh_proxy_static_ip.address]
}
