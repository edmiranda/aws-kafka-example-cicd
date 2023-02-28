resource "aws_codebuild_project" "build" {
  name         = "${var.name}-build"
  service_role = aws_iam_role.codebuild.arn
  tags         = var.tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.codebuild_configuration["cb_compute_type"]
    image           = var.codebuild_configuration["cb_image"]
    type            = var.codebuild_configuration["cb_type"]
    privileged_mode = "true"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-build.yml"
  }
}

resource "aws_codebuild_project" "deploy" {
  name         = "${var.name}-deploy"
  service_role = aws_iam_role.codebuild.arn
  tags         = var.tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-deploy.yml"
  }
  
  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.private_subnets

    security_group_ids = [aws_security_group.codebuild.id]
  }
}

resource "aws_security_group" "codebuild" {
  name        = "${var.name}-codebuild-sg"
  description = "SG codebuild deploy step"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.tags
}