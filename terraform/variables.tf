variable "username" {
  type        = string
  description = "The username for the generic secret"
  default     = "imesh"
}

variable "password" {
  type        = string
  description = "The password for the generic secret"
  default     = "1234"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace for the applications"
  default     = "k8s"
}
