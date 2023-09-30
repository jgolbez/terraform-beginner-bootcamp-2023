resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = random_string.bucket_name.result
  tags = {
    UserUUID = var.user_uuid
  }
}

