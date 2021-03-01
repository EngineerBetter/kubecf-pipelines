resource "google_compute_address" "gorouter_static_ip" {
  name   = "kubecf-gorouter"
  region = var.region
}

resource "google_compute_address" "ssh_proxy_static_ip" {
  name   = "kubecf-ssh-proxy"
  region = var.region
}
