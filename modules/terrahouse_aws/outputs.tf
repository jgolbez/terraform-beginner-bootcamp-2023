output "s3_website_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "website_url" {
    value = aws_s3_bucket_website_configuration.website_configuration.website_domain
}

output "website_endpoint" {
    value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}