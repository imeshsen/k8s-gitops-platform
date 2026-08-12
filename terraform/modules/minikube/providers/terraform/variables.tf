variable "terraform_source" {
  type        = string
  description = "Helm provider source"
  default     = "hashicorp/helm"
}

variable "terraform_version" {
  type        = string
  description = "Helm provider version"
  default     = "~> 2.13"
}