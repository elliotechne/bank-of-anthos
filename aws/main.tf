terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.13.0"
    }
  }
}

provider "aws" {
  region     = var.region
}

resource "aws_s3_bucket" "test" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags = {
    Name        = "Test Bucket"
    Environment = "Dev"
  }
}
