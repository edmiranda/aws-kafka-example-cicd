############ Codepipeline ############ 
resource "aws_iam_role" "codepipeline" {
  description = "CodePipeline Service Role"
  tags        = var.tags
  name        = "CodePipeline_SSO_Permission_Sets_Provision_Role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codepipeline.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  inline_policy {
    name = "codepipeline_execute_policy"
    policy = data.aws_iam_policy_document.codepipeline.json
  }
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid = "SSOCodePipelineAllow"

    actions = [
      "s3:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      aws_iam_role.codebuild.arn,
    ]
  }

  statement {
    actions = [
      "codecommit:BatchGet*",
      "codecommit:BatchDescribe*",
      "codecommit:Describe*",
      "codecommit:Get*",
      "codecommit:List*",
      "codecommit:GitPull",
      "codecommit:UploadArchive",
      "codecommit:GetBranch",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:BatchGetBuilds",
    ]

    resources = [
      aws_codebuild_project.build.arn,
      aws_codebuild_project.deploy.arn,
    ]
  }
}

############ Codebuild ############ 

resource "aws_iam_role" "codebuild" {
  description = "CodeBuild Service Role"
  tags        = var.tags
  name        = "CodeBuild_SSO_Permission_Sets_Provision_Role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  inline_policy {
    name = "codebuild_execute_policy"
    policy = data.aws_iam_policy_document.codebuild.json
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = "SSOCodebuildAllow"

    actions = [
      "s3:*",
      "kms:*",
      "ssm:*",
      "ecr:*",
      "eks:*",
      "ec2:*"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "sso:ListInstances",
      "sso:DescribePermissionSet",
      "sso:ListTagsForResource",
      "sso:GetInlinePolicyForPermissionSet",
      "sso:ListAccountAssignments",
      "sso:CreateAccountAssignment",
      "sso:DescribeAccountAssignmentCreationStatus",
      "sso:DeleteAccountAssignment",
      "sso:DescribeAccountAssignmentDeletionStatus",
      "sso:CreatePermissionSet",
      "sso:PutInlinePolicyToPermissionSet",
      "sso:ProvisionPermissionSet",
      "sso:DeleteInlinePolicyFromPermissionSet",
      "sso:DescribePermissionSetProvisioningStatus",
      "sso:DeletePermissionSet",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "identitystore:ListGroups",
    ]

    resources = [
      "*",
    ]
  }
}