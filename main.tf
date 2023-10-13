terraform {
  # cloud {
  #   organization = "FrustratedIncorporated"
  #   workspaces {
  #     name = "Terra-house"
  #   }
  #}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacher_seat_uuid
  token     = var.terratowns_token
}


module "terrahouse_aws" {
  source                 = "./modules/terrahouse_aws"
  teacher_seat_uuid      = var.teacher_seat_uuid
  s3_website_bucket_name = var.s3_website_bucket_name
  index_html_filepath    = var.index_html_filepath
  error_html_filepath    = var.error_html_filepath
  content_version        = var.content_version
  assets_path            = var.assets_path
}

resource "terratowns_home" "home" {
  name        = "Star Ocean: The Second Story"
  description = "What a cool game"
  domain_name = module.terrahouse_aws.cloudfront_url
  #domain_name = "blah4353637.cloudfront.net"
  town            = "missingo"
  content_version = 1
}