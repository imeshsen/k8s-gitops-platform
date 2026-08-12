module "terraform" {
  source            = "../../modules/minikube/providers/terraform"
  terraform_source  = var.terraform_source
  terraform_version = var.terraform_version
}

module "helm" {
  source         = "../../modules/minikube/providers/helm"
  config_path    = var.config_path
  config_context = var.config_context
}

module "kubernetes" {
  source         = "../../modules/minikube/providers/k8s"
  config_path    = var.config_path
  config_context = var.config_context
}