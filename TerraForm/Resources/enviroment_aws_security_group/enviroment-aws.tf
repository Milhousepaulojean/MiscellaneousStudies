resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "vpc-${var.prefix}"
  }
}

data "aws_availability_zones" "zone" {}

# output "az" {
#   value = "${data.aws_availability_zones.zone.names}"
# }


resource "aws_subnet" "aws-subnet-1" {
  availability_zone = "sa-east-1a"
  vpc_id = aws_vpc.new-vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    "name" = "subnet-${var.prefix}"
  }
}