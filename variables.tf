variable "teacher_seat_uuid" {
  type = string
}

variable "user_uuid" {
  type = string
}

variable "terratowns_endpoint" {
  type = string
}

variable "terratowns_token" {
  type = string
}

#variable "s3_website_bucket_name" {
#  type = string
#}

variable "content_version" {
  type = number
}

variable "public_path" {
  type = string
}

variable "planescape" {
  type = object({
    public_path     = string
    content_version = number
  })
}

variable "starocean2" {
  type = object({
    public_path     = string
    content_version = number
  })
}