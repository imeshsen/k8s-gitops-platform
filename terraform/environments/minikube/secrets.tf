module "minikube_secrets" {
  source    = "../../modules/minikube/secrets"
  namespace = var.namespace
  username  = var.username
  password  = var.password
}