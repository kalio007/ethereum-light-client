provider "aws" {
  region = var.region
}

resource "aws_vpc" "eth_node_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Ethereum Light Node VPC"
  }
}
resource "aws_instance" "eth_light_node" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  user_data = file("../scripts/user-data.sh")

  tags = {
    Name = "Ethereum Light Node"
  }
}
