resource "kubernetes_secret_v1" "secret" {
  metadata {
    name      = "basic-auth"
    namespace = var.namespace
  }

  data = {
    username = var.username
    password = var.password
  }

  type = "kubernetes.io/basic-auth"
}