
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_website_bucket_name
  tags = {
    UserUUID = var.user_uuid
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  content_type = "text/html"
  source = var.index_html_filepath
  etag = filemd5(var.index_html_filepath)  
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  content_type = "text/html"
  source = var.error_html_filepath
  etag = filemd5(var.error_html_filepath)  
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
            "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
            "Effect" = "Allow",
            "Principal" = {
                "Service" = "cloudfront.amazonaws.com"
            },
            "Action" = "s3:GetObject",
            "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
            "Condition" = {
            "StringEquals" = {
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        },         
})
}