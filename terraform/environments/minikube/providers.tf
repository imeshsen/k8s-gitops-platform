module "terraform" {
  source            = "../../modules/minikube/providers/terraform"
  terraform_source  = var.terraform_source
  terraform_version = var.terraform_version
}

provider "helm" {
  kubernetes {
    config_path    = var.config_path
    config_context = var.config_context
  }
}

provider "kubernetes" {
  config_path    = var.config_path
  config_context = var.config_context
}
