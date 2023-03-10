output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_cluster.configure_kubectl
}

output "eks_module_message" {
  description = "Documentation EKS Blueprints Terraform"
  value       = module.eks_cluster.eks_module_message
}