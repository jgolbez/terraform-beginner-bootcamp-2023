variable "user_uuid" {
  description = "User UUID for the S3 bucket"
  type        = string
  default     = "123e4567-e89b-12d3-a456-426655440000"

  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}


variable "s3_website_bucket_name" {
  description = "Name of the AWS S3 bucket for website"
  type        = string
  default     = "s3websitebucket-tmcc93020231038am"
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.s3_website_bucket_name))
    error_message = "S3 bucket name must be between 3 and 63 characters, containing only lowercase letters, numbers, hyphens, and periods, and it cannot start or end with a hyphen or period."
  }
}
