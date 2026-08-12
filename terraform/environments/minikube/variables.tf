variable "username" {
  type        = string
  description = "The username for the generic secret"
}

variable "password" {
  type        = string
  description = "The password for the generic secret"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace for the applications"
}

variable "namespace" {
  type        = string
  description = "Minikube cluster namespace"
}

variable "config_path" {
  type        = string
  description = "The path for the kube config"
}

variable "config_context" {
  type        = string
  description = "The cluster name"
}