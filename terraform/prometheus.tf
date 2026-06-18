resource "helm_release" "prom" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "29.12.0"
  namespace        = "monitoring"
  create_namespace = true
}