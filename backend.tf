terraform {
  backend "s3" {
    bucket = "terraform-state-fiap-paulinho02"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}
