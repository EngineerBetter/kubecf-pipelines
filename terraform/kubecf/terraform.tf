provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
provider "kubernetes" {
  config_path = "../../../kubeconfig/kubeconfig"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    acme = {
      source = "terraform-providers/acme"
    }
    tls = {
      source = "hashicorp/tls"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
  required_version = ">= 0.13"
}
