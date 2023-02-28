variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "public_subnets" {
  type    = list(any)
  default = []
}
variable "private_subnets" {
  type = list(any)
}

variable "cluster_version" {
  type = string
}

variable "cluster_log_type" {
  type = list(any)
}

variable "log_group_retention_in_days" {
  type = number
}

variable "create_iam_role" {
  type = bool
}

variable "cluster_role_arn" {
  type    = string
  default = ""
}

variable "node_role_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "map_roles" {
  type    = list(any)
  default = []
}

variable "enable_cluster_encryption" {
  type    = bool
  default = false
}

variable "azs" {
  type = list(any)
}

variable "secrets_store_csi_driver" {
  type    = bool
  default = false
}

variable "secrets_store_csi_driver_provider_aws" {
  type    = bool
  default = false
}

variable "strimzi_kafka_operator" {
  type = bool
  default = false
}

variable "amazon_eks_vpc_cni" {
  type    = bool
  default = false
}

variable "amazon_eks_coredns" {
  type    = bool
  default = false
}

variable "amazon_eks_kube_proxy" {
  type    = bool
  default = false
}

variable "amazon_eks_aws_ebs_csi_driver" {
  type    = bool
  default = false
}

variable "aws_load_balancer_controller" {
  type    = bool
  default = false
}

variable "aws_cloudwatch_metrics" {
  type    = bool
  default = false
}

variable "amazon_prometheus" {
  type    = bool
  default = false
}

variable "coredns_cluster_proportional_autoscaler" {
  type    = bool
  default = false
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source"
  type        = any
  default     = {}
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "node_groups" {
  type    = list(any)
  default = []
}