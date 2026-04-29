# aws_infra/ec2/terraform.tfvars
region                     = "ap-northeast-2"
prefix                     = "aws04"
key_name                   = "aws04-key"
instance_type              = "t3.micro"
ami_id                     = "ami-0765f9741eedf9c7b" # ubuntu 24.04 LTS (HVM)