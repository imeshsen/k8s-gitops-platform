resource "kubernetes_namespace" "k8s" {
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