variable "teacher_seat_uuid" {
  description = "User UUID for Terratowns server"
  type        = string
  default     = "123e4567-e89b-12d3-a456-426655440000"

  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.teacher_seat_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}

variable "user_uuid" {
  description = "User UUID for S3 Bucket"
  type        = string
  default     = "123e4567-e89b-12d3-a456-426655440000"

  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}

variable "terratowns_endpoint" {
  type = string
  default = "https://terratowns.cloud/api"
}

variable "terratowns_token" {
  type = string
  default = "563893jdjdduj9j94j9fu94u"
}

#variable "s3_website_bucket_name" {
#  description = "Name of the AWS S3 bucket for website"
#  type        = string
#  default     = "s3websitebucket-tmcc93020231038am"
# validation {
#   condition     = (
#       length(var.s3_website_bucket_name) >= 3 && length(var.s3_website_bucket_name) <= 63 &&
#        can(regex("^[a-z0-9.-]{3,63}$", var.s3_website_bucket_name)))
#    error_message = "S3 bucket name must be between 3 and 63 characters, containing only lowercase letters, numbers, hyphens, and periods, and it cannot start or end with a hyphen or period."
#  }
#}

variable "public_path" {
    description = "File path to website"
    type = string
}

# variables.tf

variable "content_version" {
  description = "The content version (positive integer starting from 1)"
  type        = number

  validation {
    condition     = var.content_version >= 1 && can(regex("^[0-9]+$", tostring(var.content_version)))
    error_message = "Content version must be a positive integer starting from 1."
  }
}
