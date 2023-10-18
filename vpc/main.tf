resource "aws_vpc" "app-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "WebApp-VPC"
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "WebApp-IGW"
  }
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags = {
    Name = "Web-RT"
  }
}

resource "aws_subnet" "pub-snet-1" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PUB-SUBNET-1"
  }
}

resource "aws_subnet" "pub-snet-2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PUB-SUBNET-2"
  }
}

resource "aws_subnet" "db-snet-1" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "DB-SUBNET-1"
  }
}
resource "aws_subnet" "db-snet-2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "eu-central-1b"
  tags = {
    Name = "DB-SUBNET-2"
  }
}

resource "aws_route_table_association" "pub-sub-1-rt" {
  subnet_id      = aws_subnet.pub-snet-1.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "pub-sub-2-rt" {
  subnet_id      = aws_subnet.pub-snet-2.id
  route_table_id = aws_route_table.web-rt.id
}