resource "aws_security_group" "eth_node_sg" {
  name        = "ethereum-node-sg"
  description = "Security group for Ethereum Light Node"
  vpc_id      = aws_vpc.eth_node_vpc.id

  ingress {
    from_port   = 8345
    to_port     = 8345
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Access (Restricted)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ethereum Node Security Group"
  }
}