# aws_infra/asg/data.tf

data "aws_vpc" "aws04_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws04_private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-private-subnet-*"]
  }
}
data "aws_security_group" "aws04_ssh_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-ssh-sg"]
  }
}
data "aws_security_group" "aws04_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}
data "aws_iam_instance_profile" "aws04_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}
data "aws_ami" "aws04_instance" {
  most_recent = true
  owners = ["self"]
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-instance-ami"]
  }
}
data "aws_lb_target_group" "aws04_alb_was_group" {
  name   = "${var.prefix}-alb-was-group"
}