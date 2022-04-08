terraform {
   required_version = ">= 0.12"
  required_providers {
    aws = ">= 4.8.0"
    local = ">= 2.2.2"
  }
}

provider "aws" {
  region = "sa-east-1"
}

variable "prefix" {
   default="terraform"
}
