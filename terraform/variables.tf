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

