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
  }
}

provider "aws" {
  # Configuration options
}


module "terrahouse_aws" {
  source                 = "./modules/terrahouse_aws"
  user_uuid              = var.user_uuid
  s3_website_bucket_name = var.s3_website_bucket_name
  index_html_filepath    = var.index_html_filepath
  error_html_filepath    = var.error_html_filepath
  content_version        = var.content_version
}
