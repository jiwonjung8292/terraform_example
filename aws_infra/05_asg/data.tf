# aws_infra/asg/data.tf
data "aws_ami" "aws04_ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-instance-ami"]
  }
}

data "aws_vpc" "aws04_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws04_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.aws04_vpc.id]
  }
  filter {
    name = "tag:Name"
    values = ["${var.prefix}-private-*"]
  }
}

data "aws_security_group" "aws04_was_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}

data "aws_iam_instance_profile" "aws04_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}

data "aws_lb_target_group" "aws04_was_tg" {
  name   = "${var.prefix}-alb-was-group"
}