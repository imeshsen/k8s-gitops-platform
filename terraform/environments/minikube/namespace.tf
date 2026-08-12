resource "kubernetes_namespace_v1" "k8s" {
  metadata {
    annotations = {
      name = "k8s"
    }
    labels = {
      mylabel = "k8s"
    }
    name = "k8s"
  }
}
