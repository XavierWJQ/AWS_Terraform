resource "aws_codebuild_project" "BB-plan" {
  name          = "BB-cicd-plan"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.BB_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.1.7"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/plan-buildspec.yml")
 }
}

resource "aws_codebuild_project" "BB-apply" {
  name          = "BB-cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.BB_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.1.7"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/apply-buildspec.yml")
 }
}

resource "aws_codebuild_project" "BB-destroy" {
  name          = "BB-cicd-destroy"
  description   = "Destroy stage for terraform"
  service_role  = aws_iam_role.BB_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.1.7"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/destroy-buildspec.yml")
 }
}



resource "aws_codepipeline" "cicd_pipeline" {

    name = "BB-cicd"
    role_arn = aws_iam_role.BB_codepipeline_role.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["BB-code"]
            configuration = {
                FullRepositoryId = "XavierWJQ/aws_cicd_pipeline_BB"
                BranchName   = var.source_repo_branch
                ConnectionArn = var.codestar_credentials
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["BB-code"]
            configuration = {
                ProjectName = "BB-cicd-plan"
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["BB-code"]
            configuration = {
                ProjectName = "BB-cicd-apply"
            }
        }
    }
    stage {
        name ="Destroy"
        action{
            name = "Destroy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["BB-code"]
            configuration = {
                ProjectName = "BB-cicd-destroy"
            }
        }
    }
}