
tags = {
  service     = "EKS",
  environment = "PROD",
  DeployedBy  = "Eduardo Miranda"
  tf-module   = "funcionario-eks-blueprints-terraform"
}

map_roles = [
  {
    rolearn  = "arn:aws:iam::<AWS Account Number>:role/Admin"
    username = "ops-role"         # The user name within Kubernetes to map to the IAM role
    groups   = ["system:masters"] # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
  },
  {
    rolearn  = "arn:aws:iam::<AWS Account Number>:role/CodeBuild_SSO_Permission_Sets_Provision_Role"
    username = "ci-cd-pipeline"         # The user name within Kubernetes to map to the IAM role
    groups   = ["system:masters"] # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
  }
]

cluster_security_group_additional_rules = {
  onprem_private_access_ingress = {
    description = "OnPrem Private Ingress"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    type        = "ingress"
    cidr_blocks = ["0.0.0.0/0"] #Origin Access to Cluster
  }
}

node_security_group_additional_rules = {
  # Extend node-to-node security group rules. Recommended and required for the Add-ons
  ingress_self_all = {
    description = "Node to node all ports/protocols"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    type        = "ingress"
    self        = true
  }
  # Recommended outbound traffic for Node groups
  egress_all = {
    description      = "Node all egress"
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    type             = "egress"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  # Allows Control Plane Nodes to talk to Worker nodes on all ports. Added this to simplify the example and further avoid issues with Add-ons communication with Control plane.
  # This can be restricted further to specific port based on the requirement for each Add-on e.g., metrics-server 4443, spark-operator 8080, karpenter 8443 etc.
  # Change this according to your security requirements if needed
  ingress_cluster_to_node_all_traffic = {
    description                   = "Cluster API to Nodegroup all traffic"
    protocol                      = "-1"
    from_port                     = 0
    to_port                       = 0
    type                          = "ingress"
    source_cluster_security_group = true
  }
}

#Autoscaling Group EKS Nodes
node_groups = [
  {
    name               = "node-group-1"
    instance_type      = "m5.xlarge"
    desired_size       = "3"
    max_size           = "3"
    min_size           = "3"
    max_unavailable    = "3"
    capacity_type      = "ON_DEMAND"
    disk_size          = "50"
    launch_template_os = "amazonlinux2eks"
    max_pods           = "44"
  }
]

# Networking
azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_id = "vpc-xxxxxxx"
private_subnets = [
  "subnet-xxxxxxx",
  "subnet-xxxxxxx",
  "subnet-xxxxxxx"
]

private_subnets_cidr_blocks = [
  "x.x.x.x/x",
  "x.x.x.x/x",
  "x.x.x.x/x"
]

private_route_table_ids = [
  "rtb-xxxxxxx"
]

#Codepipeline
repository       = "Funcionario"
repository_branch = "master"
codebuild_configuration = {
  cb_compute_type = "BUILD_GENERAL1_SMALL"
  cb_image        = "aws/codebuild/standard:5.0"
  cb_type         = "LINUX_CONTAINER"
}

# ECR

repository_read_write_access_arns = ["arn:aws:iam::<AWS Account Number>:role/Admin"]