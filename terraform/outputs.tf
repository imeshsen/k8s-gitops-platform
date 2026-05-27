output "cluster_endpoint" {
  value       = data.aws_eks_cluster.cluster.endpoint
  description = "EKS cluster API endpoint"
}

output "cluster_name" {
  value       = var.cluster_name
  description = "EKS cluster name"
}

output "region" {
  value       = var.aws_region
  description = "AWS region"
}

output "argocd_release_status" {
  value       = helm_release.argocd.status
  description = "Status of the ArgoCD Helm release"
}

