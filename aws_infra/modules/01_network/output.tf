# network/output.tf
output "vpc_id" {
  value = aws_vpc.aws04_vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.aws04_public_subnet[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.aws04_private_subnet[*].id
}
output "ssh_sg_id" {
  value = aws_security_group.aws04_ssh_sg.id
}
output "http_sg_id" {
  value = aws_security_group.aws04_http_sg.id
}