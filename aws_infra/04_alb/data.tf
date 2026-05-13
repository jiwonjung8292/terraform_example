# aws_infra/alb/data.tf
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

# data "aws_vpc" "aws04_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-vpc"]
#   }
# }
# data "aws_subnets" "aws04_public_subnets" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-public-subnet-*"]
#   }
# }
# data "aws_security_group" "aws04_http_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-http-sg"]
#   }
# }