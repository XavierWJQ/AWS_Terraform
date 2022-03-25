#Random ID for unique naming
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}



locals {
    name_prefix = "building-blocs"
    s3_bucket_name = lower("${local.name_prefix}-${random_integer.rand.result}")
}