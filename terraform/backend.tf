terraform {
  backend "s3" {
    bucket = "eth-client"
    key = "terraform/backend"
    region = "us-east-1"
  }
}