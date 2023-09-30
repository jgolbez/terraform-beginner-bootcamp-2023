terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_website_bucket_name
  tags = {
    UserUUID = var.user_uuid
  }
}

