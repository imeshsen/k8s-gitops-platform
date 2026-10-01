resource "kubernetes_namespace_v1" "k8s" {
  for_each = var.namespace

  metadata {
    annotations = {
      name = each.value
    }
    labels = {
      mylabel = each.value
    }
    name = each.value
  }
}