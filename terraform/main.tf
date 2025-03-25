provider "aws" {
  region = var.region
}

resource "aws_vpc" "eth_node_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Ethereum Light Node VPC"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.eth_node_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "${var.region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "Ethereum Node Public Subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.eth_node_vpc.id

  tags = {
    Name = "Ethereum Node IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eth_node_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
