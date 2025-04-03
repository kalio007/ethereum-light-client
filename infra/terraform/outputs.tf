output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eth_node_vpc.id
}
output "ethereum_node_public_ip" {
  value = aws_instance.eth_node.public_ip
}
