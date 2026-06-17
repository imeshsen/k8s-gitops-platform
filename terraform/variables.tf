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
