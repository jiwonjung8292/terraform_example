output "jenkins_instance_id" {
  value = aws_instance.aws04_jenkins_server.id
}

output "jenkins_private_ip" {
  value = aws_instance.aws04_jenkins_server.private_ip
}