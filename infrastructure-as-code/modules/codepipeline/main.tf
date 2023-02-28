resource "aws_codepipeline" "permission_sets_pipeline" {
  name     = "${var.name}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn
  tags     = var.tags

  artifact_store {
    location = aws_s3_bucket.artifacts.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      input_artifacts  = []
      version          = "1"
      output_artifacts = ["CodeWorkspace"]

      configuration = {
        RepositoryName       = var.repository
        BranchName           = var.repository_branch
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "Build"

    action {
      run_order        = 1
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = ["Artifact"]
      version          = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.build.name
        EnvironmentVariables = jsonencode([
          {
            name  = "PIPELINE_EXECUTION_ID"
            value = "#{codepipeline.PipelineExecutionId}"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  stage {
    name = "Manual-Approval"

    action {
      run_order = 1
      name             = "AWS-Admin-Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
      input_artifacts  = []
      output_artifacts = []

      configuration = {
        CustomData = "Please verify the build output on the Build stage and only approve this step if you see expected changes!"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      run_order        = 1
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = []
      version          = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.deploy.name
        PrimarySource        = "CodeWorkspace"
        EnvironmentVariables = jsonencode([
          {
            name  = "PIPELINE_EXECUTION_ID"
            value = "#{codepipeline.PipelineExecutionId}"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
}