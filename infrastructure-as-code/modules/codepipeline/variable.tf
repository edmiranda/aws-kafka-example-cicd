variable "codebuild_configuration" {
  type    = map(string)
  default = {
    cb_compute_type = "BUILD_GENERAL1_SMALL"
    cb_image        = "aws/codebuild/standard:5.0"
    cb_type         = "LINUX_CONTAINER"
  }
}

variable "name" {
  type = string
}

variable "tags" {
  type = map
}

variable "repository" {
  type = string
}

variable "repository_branch" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list
}