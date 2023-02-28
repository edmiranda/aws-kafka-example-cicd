locals {

  name_prefix     = "funcionario"
  region          = data.aws_region.current.name
  cluster_version = "1.24"

  cluster_log_type                = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  log_group_retention_in_days     = 1
  create_iam_role                 = false
  enable_cluster_encryption       = true
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  # Add-ons
  secrets_store_csi_driver              = false
  secrets_store_csi_driver_provider_aws = false
  strimzi_kafka_operator                = false

  # EKS Managed Addons
  amazon_eks_vpc_cni                      = true
  amazon_eks_coredns                      = true
  amazon_eks_kube_proxy                   = true
  amazon_eks_aws_ebs_csi_driver           = true
  coredns_cluster_proportional_autoscaler = false
  aws_load_balancer_controller            = true
  aws_cloudwatch_metrics                  = true
}
