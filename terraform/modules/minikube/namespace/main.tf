resource "kubernetes_namespace_v1" "k8s" {
  metadata {
    annotations = {
      name = var.namespace
    }
    labels = {
      mylabel = var.namespace
    }
    name = var.namespace
  }
}