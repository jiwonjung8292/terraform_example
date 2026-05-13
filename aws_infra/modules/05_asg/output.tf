#asg/output.tf

output "asg_name" {
  value = aws_autoscaling_group.aws04_was_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.aws04_was_lt.id
}