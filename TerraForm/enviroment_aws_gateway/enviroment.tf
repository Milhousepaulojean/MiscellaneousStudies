resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "vpc-1"
  }
}

data "aws_availability_zones" "zone" {}

resource "aws_subnet" "sbnet-1" {
  availability_zone = "sa-east-1a"
  vpc_id = aws_vpc.new-vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    "name" = "subnet1"
  }
}

resource "aws_internet_gateway" "iegateway" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    "name" = "${var.prefix}-igtw"
  }
}

resource "aws_route_table" "rt_table" {
  vpc_id = aws_vpc.new-vpc.id
  route  {
      cidr_block= "0.0.0.0/0"
      gateway_id = aws_internet_gateway.iegateway.id
  }
  tags = {
    "Name" = "${var.prefix}-route_table"
  }
}

resource "aws_route_table_association" "rtb_association" {
    count = 2
    route_table_id =  aws_route_table.rt_table.id 
    subnet_id =  aws_subnet.sbnet-1.id
}