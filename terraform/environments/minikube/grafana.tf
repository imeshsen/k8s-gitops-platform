module "grafana" {
  source        = "../../modules/minikube/helm-release"
  name          = "grafana"
  repository    = "https://grafana-community.github.io/helm-charts"
  chart         = "grafana"
  chart_version = "13.2.7"
  namespace     = "monitoring"

  depends_on = [module.namespace]
}
