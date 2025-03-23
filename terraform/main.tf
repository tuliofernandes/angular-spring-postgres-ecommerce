# Setup S3 bucket for Terraform state
terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket         = "ecom-app-terraform-state"
    key            = "terraform/state"
    region         = "sa-east-1"
    encrypt        = true
  }
}


provider "aws" {
  region = "sa-east-1"
}
