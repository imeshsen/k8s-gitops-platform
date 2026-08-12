module "namespace" {
  source    = "../../modules/minikube/namespace"
  namespace = var.namespace
}