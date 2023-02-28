# Inputs Variables
variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}
variable "public_subnets" {
  type    = list(any)
  default = []
}
variable "private_subnets" {
  type    = list(any)
  default = []
}

variable "cluster_role_arn" {
  type    = string
  default = ""
}

variable "node_role_arn" {
  type    = string
  default = ""
}

variable "map_roles" {
  type = list(any)
}

variable "azs" {
  type    = list(any)
  default = []
}

variable "cluster_security_group_additional_rules" {
  type    = any
  default = {}
}

variable "node_security_group_additional_rules" {
  type        = any
  default     = {}
}

variable "node_groups" {
  type    = list(any)
  default = []
}

variable "private_subnets_cidr_blocks" {
  type = list(any)
}

variable "private_route_table_ids" {
  type = list(any)
}

variable "repository" {
  type = string
}

variable "repository_branch" {
  type = string
}

variable "codebuild_configuration" {
  type = map
}

variable "repository_read_write_access_arns" {
    type = list
}

