output "argocd_release_status" {
  value       = module.argocd.status
  description = "Status of the ArgoCD Helm release"
}

output "grafana_release_status" {
  value       = module.grafana.status
  description = "Status of the Grafana Helm release"
}
