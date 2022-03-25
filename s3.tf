resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = local.s3_bucket_name
  acl    = "private"
}