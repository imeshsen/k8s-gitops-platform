resource "kubernetes_secret" "generic_secret" {
  metadata {
    name      = "generic-secret"
    namespace = kubernetes_namespace.k8s.metadata[0].name
  }

  data = {
    username = var.username
    password = var.password
  }

  type = "Opaque"
}
