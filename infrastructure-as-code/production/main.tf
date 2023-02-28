###### EKS Cluster ######

module "eks_cluster" {
  source = "../modules/eks_cluster"

  name = "${local.name_prefix}-eks"

  # Networking
  vpc_id            = var.vpc_id
  private_subnets   = var.private_subnets
  azs               = var.azs

  # Cluster Config
  cluster_version                 = local.cluster_version
  cluster_log_type                = local.cluster_log_type
  log_group_retention_in_days     = local.log_group_retention_in_days
  enable_cluster_encryption       = local.enable_cluster_encryption
  cluster_endpoint_public_access  = local.cluster_endpoint_public_access
  cluster_endpoint_private_access = local.cluster_endpoint_private_access

  # Cluster IAM Roles
  create_iam_role  = local.create_iam_role
  cluster_role_arn = module.eks_cluster_role.role_arn
  node_role_arn    = module.eks_node_role.role_arn

  # Cluster ASG Config
  node_groups    = var.node_groups

  # Add-ons
  secrets_store_csi_driver              = local.secrets_store_csi_driver
  secrets_store_csi_driver_provider_aws = local.secrets_store_csi_driver_provider_aws
  strimzi_kafka_operator                = local.strimzi_kafka_operator

  # EKS Managed Addons
  amazon_eks_vpc_cni                      = local.amazon_eks_vpc_cni
  amazon_eks_coredns                      = local.amazon_eks_coredns
  amazon_eks_kube_proxy                   = local.amazon_eks_kube_proxy
  amazon_eks_aws_ebs_csi_driver           = local.amazon_eks_aws_ebs_csi_driver
  coredns_cluster_proportional_autoscaler = local.coredns_cluster_proportional_autoscaler
  aws_cloudwatch_metrics                  = local.aws_cloudwatch_metrics
  aws_load_balancer_controller            = local.aws_load_balancer_controller

  # Cluster Security Group
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  
  # Nodes Security Group
  node_security_group_additional_rules    = var.node_security_group_additional_rules

  tags = var.tags

  map_roles = var.map_roles

}

###### IAM Roles ######

module "eks_cluster_role" {
  source = "../modules/eks_cluster_role"

  name = "${local.name_prefix}-eks-cluster-role"

}

module "eks_node_role" {
  source = "../modules/eks_node_role"

  name = "${local.name_prefix}-eks-node-role"

}

###### VPC Endpoints ######

module "eks_vpc_endpoints" {
  source = "../modules/eks_vpc_endpoints"

  name = "${local.name_prefix}-eks-vpc-endpoints"

  vpc_id                      = var.vpc_id
  private_subnets             = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  private_route_table_ids     = var.private_route_table_ids

  tags = var.tags

}

###### Code Pipeline ######

module "codepipeline" {
  source = "../modules/codepipeline"

  name                    = "${local.name_prefix}-pipeline"
  tags                    = var.tags
  repository              = var.repository
  repository_branch       = var.repository_branch
  codebuild_configuration = var.codebuild_configuration
  vpc_id                  = var.vpc_id
  private_subnets         = var.private_subnets
  
}

###### ECR ######

module "consumer" {
  source = "../modules/ecr"

  name                              = "${local.name_prefix}-consumer"
  tags                              = var.tags
  repository_read_write_access_arns = var.repository_read_write_access_arns
  
}

module "publisher" {
  source = "../modules/ecr"

  name                              = "${local.name_prefix}-publisher"
  tags                              = var.tags
  repository_read_write_access_arns = var.repository_read_write_access_arns
  
}