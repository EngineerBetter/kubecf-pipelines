resource "kubernetes_storage_class" "pd-ssd" {
  metadata {
    name = "pd-ssd"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Delete"
  parameters = {
    type = "pd-ssd"
  }
}
