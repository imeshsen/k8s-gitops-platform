module "argocd" {
  source           = "../../modules/minikube/helm-release"
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  chart_version    = "5.51.6"
  namespace        = "argocd"
  create_namespace = true
}

moved {
  from = helm_release.argocd
  to   = module.argocd.helm_release.release
}
