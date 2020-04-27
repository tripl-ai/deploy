# provider.tf

# terraform {
#   backend "s3" {
#     region = "ap-southeast-2"
#     bucket = "tf-state-arcdemo2020"
#     key    = "jupyter.terraform.tfstate"
#   }
# }

# Specify the provider and access details
provider "aws" {
  profile = "default"
  region  = var.aws_region
}

