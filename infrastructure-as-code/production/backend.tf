terraform {
  backend "s3" {
    bucket = "terraform-iac-state-v1"
    key    = "eks-blueprints/production/terraform.tfstate"
    region = "us-east-1"
  }
}