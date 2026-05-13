# jenkins/data.tf
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "alb/terraform.tfstate"
    region = var.region
  }
}

data "aws_iam_instance_profile" "aws04_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}
# data "aws_vpc" "aws04_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-vpc"]
#   }
# }

# data "aws_subnets" "aws04_private_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.aws04_vpc.id]
#   }
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-private-*"]
#   }
# }

# data "aws_security_group" "aws04_ssh_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-ssh-sg"]
#   }
# }

# data "aws_security_group" "aws04_http_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.prefix}-http-sg"]
#   }
# }

# data "aws_iam_instance_profile" "aws04_ec2_profile" {
#   name = "${var.prefix}-ec2-instance-profile"
# }

# data "aws_lb_target_group" "aws04_jenkins_tg" {
#   name = "${var.prefix}-alb-jenkins-group"
# }