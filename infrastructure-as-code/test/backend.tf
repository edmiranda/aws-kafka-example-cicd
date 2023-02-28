terraform {
  backend "s3" {
    bucket = "terraform-iac-state-v1"
    key    = "eks-blueprints/test/terraform.tfstate"
    region = "us-east-1"
  }
}