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
  tags = {
    Name = "Ethereum Node Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
resource "aws_key_pair" "ethereum_node_key" {
  key_name   = "ethereum_node"
  public_key = file("${var.private_key_path}.pub")
}

# EC2 Instance for Ethereum Node
resource "aws_instance" "eth_node" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ethereum_node_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eth_node_sg.id]

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "Ethereum Light Node"
  }

  # Generate Ansible inventory
  provisioner "local-exec" {
    command = <<-EOT
      echo "[ethereum_nodes]" > inventory.ini
      echo "${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.private_key_path}" >> inventory.ini
    EOT
  }
}
