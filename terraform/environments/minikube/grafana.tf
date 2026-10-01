module "grafana" {
  source        = "../../modules/minikube/helm-release"
  name          = "grafana"
  repository    = "https://grafana-community.github.io/helm-charts"
  chart         = "grafana"
  chart_version = "13.2.7"
  namespace     = "monitoring"
  values        = [file("${path.module}/values/grafana.yaml")]

  depends_on = [module.namespace, module.minikube_secrets]
}
