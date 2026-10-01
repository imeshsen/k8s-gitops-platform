variable "name" {
  type        = string
  description = "Helm release name"
}

variable "repository" {
  type        = string
  description = "Helm chart repository URL"
}

variable "chart" {
  type        = string
  description = "Chart name in the repository"
}

variable "chart_version" {
  type        = string
  description = "Chart version to install"
}

variable "namespace" {
  type        = string
  description = "Namespace to install the release into"
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not exist"
  default     = false
}

variable "values" {
  type        = list(string)
  description = "Values files content passed to the chart"
  default     = []
}

variable "timeout" {
  type        = number
  description = "Seconds to wait for the release to become ready"
  default     = 600
}
