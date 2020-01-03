# provider.tf

# Specify the provider and access details
# provider "aws" {
#   shared_credentials_file = "$HOME/.aws/credentials"
#   profile                 = "default"
#   region                  = var.aws_region
# }

terraform {
  backend "s3" {
    region = "ap-southeast-2"
    bucket = "tf-state-arcdemo"
    key    = "dev.terraform.tfstate"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}
