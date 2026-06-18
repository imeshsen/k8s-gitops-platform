resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana-community.github.io/helm-charts"
  chart            = "grafana"
  version          = "10.5.15"
  namespace        = "monitoring"
  create_namespace = true
}
