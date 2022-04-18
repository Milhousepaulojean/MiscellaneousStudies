terraform {
    required_version = ">=0.13.1"
    required_providers {
      aws = ">=3.54.0"
      local = ">=2.1.0"
    }
    backend "s3" {
      bucket = "paulinhobucket"
      key    = "terraform.tfstate"
      region = "sa-east-1"
    }
}

provider "aws" {
  region = "sa-east-1"
}