terraform {
  backend "s3" {
      bucket = "buildingblock-terraform-state"
      encrypt = false
      key = "terraform.tfstate"
      region = "us-east-1"
      profile = "ma-sandbox"
  }
}
