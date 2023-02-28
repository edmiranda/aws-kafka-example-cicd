provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_addon_version" "latest" {
  for_each = toset(["vpc-cni"])

  addon_name         = each.value
  kubernetes_version = module.eks_blueprints.eks_cluster_version
  most_recent        = true
}

data "aws_ssm_parameter" "eks_optimized_ami" {
  name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2/recommended/image_id"
}

###### EKS Cluster ######

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.23.0"

  cluster_name = var.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = var.cluster_version

  cluster_enabled_log_types              = var.cluster_log_type
  cloudwatch_log_group_retention_in_days = var.log_group_retention_in_days
  create_iam_role                        = var.create_iam_role
  iam_role_arn                           = var.cluster_role_arn
  enable_cluster_encryption              = var.enable_cluster_encryption
  cluster_endpoint_public_access         = var.cluster_endpoint_public_access
  cluster_endpoint_private_access        = var.cluster_endpoint_private_access

  # Cluster Security Group
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  node_security_group_additional_rules    = var.node_security_group_additional_rules 

  map_roles = var.map_roles


  managed_node_groups = merge(
    { for ng in var.node_groups :
      replace(ng.name, "-", "_") =>
      {
        node_group_name = ng.name

        custom_ami_id  = data.aws_ssm_parameter.eks_optimized_ami.value
        instance_types = [ng.instance_type]

        subnet_ids      = var.private_subnets
        create_iam_role = var.create_iam_role
        iam_role_arn    = var.node_role_arn
        # pre_userdata will be applied by using custom_ami_id or ami_type
        pre_userdata = <<-EOT
              yum install -y amazon-ssm-agent
              systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent
          EOT

        # post_userdata will be applied only by using custom_ami_id
        post_userdata = <<-EOT
               cat /var/log/messages
        EOT

        desired_size           = ng.desired_size
        max_size               = ng.max_size
        min_size               = ng.min_size
        max_unavailable        = ng.max_unavailable
        capacity_type          = ng.capacity_type
        disk_size              = ng.disk_size
        create_launch_template = true
        launch_template_os     = ng.launch_template_os
        launch_template_tags   = var.tags
        
        kubelet_extra_args   = "--max-pods=${ng.max_pods}"
        bootstrap_extra_args = "--use-max-pods false"
      }
  })


  tags = var.tags
}

#---------------------------------------------------------------
# Kubernetes Addons Module
#---------------------------------------------------------------

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.19.0"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  #K8s Add-ons
  enable_secrets_store_csi_driver              = var.secrets_store_csi_driver
  enable_secrets_store_csi_driver_provider_aws = var.secrets_store_csi_driver_provider_aws
  enable_strimzi_kafka_operator                = var.strimzi_kafka_operator
 
  # EKS Managed Addons
  enable_amazon_eks_vpc_cni = var.amazon_eks_vpc_cni
  amazon_eks_vpc_cni_config = {
    # Version 1.6.3-eksbuild.2 or later of the Amazon VPC CNI is required for custom networking
    # Version 1.9.0 or later (for version 1.20 or earlier clusters or 1.21 or later clusters configured for IPv4)
    # or 1.10.1 or later (for version 1.21 or later clusters configured for IPv6) of the Amazon VPC CNI for prefix delegation
    addon_version     = data.aws_eks_addon_version.latest["vpc-cni"].version
    resolve_conflicts = "OVERWRITE"
  }
  enable_amazon_eks_coredns            = var.amazon_eks_coredns
  enable_amazon_eks_kube_proxy         = var.amazon_eks_kube_proxy
  enable_amazon_eks_aws_ebs_csi_driver = var.amazon_eks_aws_ebs_csi_driver
  enable_aws_load_balancer_controller  = var.aws_load_balancer_controller
  enable_aws_cloudwatch_metrics        = var.aws_cloudwatch_metrics

  # Disable coredns_cluster_proportional_autoscaler, it is enabled by default
  enable_coredns_cluster_proportional_autoscaler = var.coredns_cluster_proportional_autoscaler

  tags = var.tags
}