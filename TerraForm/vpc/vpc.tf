resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "create-vpc-terraform"
  }
}