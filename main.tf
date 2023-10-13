terraform {
   cloud {
     organization = "FrustratedIncorporated"
     workspaces {
       name = "Terra-house"
     }
  }
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


module "home_planescape" {
  source                 = "./modules/terrahouse_aws"
  teacher_seat_uuid      = var.teacher_seat_uuid
  s3_website_bucket_name = var.s3_website_bucket_name
  index_html_filepath    = var.index_html_filepath
  error_html_filepath    = var.error_html_filepath
  content_version        = var.content_version
  assets_path            = var.assets_path
}



module "home_starocean2" {
  source                 = "./modules/terrahouse_aws"
  teacher_seat_uuid      = var.teacher_seat_uuid
  path_to_file
  s3_website_bucket_name = var.s3_website_bucket_name
  index_html_filepath    = var.index_html_filepath
  error_html_filepath    = var.error_html_filepath
  content_version        = var.content_version
  assets_path            = var.assets_path
}


resource "terratowns_home" "planescape" {
  name        = "PlaneScape: Torment"
  description = "What Can Change the Nature of a Man?"
  domain_name = module.home_planescape.domain_name
  #domain_name = "blah4353637.cloudfront.net"
  town            = "missingo"
  content_version = 2
}

resource "terratowns_home" "starocean2" {
  name        = "Star Ocean 2"
  description = "Challenge the Sorcery Orb!"
  domain_name = module.home_starocean2.domain_name
  #domain_name = "blah4353637.cloudfront.net"
  town            = "missingo"
  content_version = 2
}