# provider.tf

# terraform {
#   backend "s3" {
#     region = "ap-southeast-2"
#     bucket = "tf-state-arcdemo2020"
#     key    = "jupyterdev.terraform.tfstate"
#   }
# }

# Specify the provider and access details
provider "aws" {
  profile = "labtest"
  region  = var.aws_region
}

