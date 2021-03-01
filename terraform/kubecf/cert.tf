locals {
  dns_zone = trimsuffix(data.google_dns_managed_zone.kubecf.dns_name, ".")
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "kube@cf.com"
}

resource "acme_certificate" "wildcard" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = "*.${local.dns_zone}"
  subject_alternative_names = [
    "*.${local.dns_zone}",
  ]

  dns_challenge {
    provider = "gcloud"
    config = {
      GCE_PROJECT             = trimprefix(data.google_project.current_project.project_id, "project/")
      GCE_PROPAGATION_TIMEOUT = "600"
    }
  }
}

data "google_project" "current_project" {}

resource "tls_private_key" "self_signed_cert" {
  algorithm = "RSA"
}
