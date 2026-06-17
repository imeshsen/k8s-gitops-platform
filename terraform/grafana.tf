resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana-community.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
}