output "was_target_group_arn" {
  value = aws_lb_target_group.aws04_alb_was_group.arn
}
output "jenkins_target_group_arn" {
  value = aws_lb_target_group.aws04_alb_jenkins_group.arn
}