terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "us-west-1"
  shared_credentials_files = var.shared_credentials_files
}