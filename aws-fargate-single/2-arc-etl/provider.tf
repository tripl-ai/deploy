# provider.tf

# terraform {
#   backend "s3" {
#     region = "ap-southeast-2"
#     bucket = "tf-state-arcdemo[ACCOUNT_ID]"
#     key    = "etldev.terraform.tfstate"
#   }
# }


# Specify the provider and access details
provider "aws" {
  region  = var.region
  profile = "default"
}
