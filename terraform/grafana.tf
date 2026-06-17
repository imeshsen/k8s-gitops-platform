resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana-community.github.io/helm-charts"
  chart            = "grafana"
  version          = "9.5.9"
  namespace        = "monitoring"
  create_namespace = true
}