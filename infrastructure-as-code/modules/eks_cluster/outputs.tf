output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

output "eks_module_message" {
  description = "Documentation EKS Blueprints Terraform"
  value       = "Please if you want to improve this module or you need understand better this module, visit the next documentation https://aws-ia.github.io/terraform-aws-eks-blueprints/main/"
}