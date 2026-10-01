module "prometheus" {
  source        = "../../modules/minikube/helm-release"
  name          = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "prometheus"
  chart_version = "29.35.0"
  namespace     = "monitoring"

  depends_on = [module.namespace]
}