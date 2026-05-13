# iam/output.tf
output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.aws04_ec2_instance_profile.name
}