resource "helm_release" "release" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.chart_version
  values           = var.values
  timeout          = var.timeout
}
