# aws_infra/asg/terraform.tfvars
region = "ap-northeast-2"
prefix = "aws04"
instance_type = "t3.medium"
key_name = "aws04-key"
ami_id = "ami-0765f9741eedf9c7b"
remote_state_bucket = "aws04-terraform-state-bucket"