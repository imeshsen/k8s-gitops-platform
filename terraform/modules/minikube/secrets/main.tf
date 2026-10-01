resource "kubernetes_secret_v1" "secret" {
  for_each = var.namespace

  metadata {
    name      = "basic-auth"
    namespace = each.value
  }

  data = {
    username = var.username
    password = var.password
  }

  type = "kubernetes.io/basic-auth"
}