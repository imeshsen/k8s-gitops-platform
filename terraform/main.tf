resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.51.6"
}

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