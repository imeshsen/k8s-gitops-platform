output "argocd_release_status" {
  value       = helm_release.argocd.status
  description = "Status of the ArgoCD Helm release"
}