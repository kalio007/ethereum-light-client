output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eth_node_vpc.id
}
