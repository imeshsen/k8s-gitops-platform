output "status" {
  value       = helm_release.release.status
  description = "Status of the Helm release"
}
