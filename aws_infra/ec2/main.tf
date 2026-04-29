# aws_infra/ec2/main.tf
resource "aws_instance" "aws04_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name      = var.key_name
  subnet_id     = data.aws_subnet.aws04_public_subnet.id
  security_groups = [
    data.aws_security_group.aws04_ssh_sg.id,
    data.aws_security_group.aws04_http_sg.id
  ]
  # CodeDeploy 에이전트, docker 설치
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y ruby wget
              sudo apt install -y --reinstall ca-certificates
              sudo update-ca-certificates --fresh
              cd /home/ubuntu
              wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              sudo systemctl start codedeploy-agent
              sudo systemctl enable codedeploy-agent
              ${file("${path.module}/user_data/docker-install.sh")}
              EOF
  tags = {
    Name = "${var.prefix}-instance"
  }
}

# 2. Code Deploy Agent, Docker 설치 대기
resource "null_resource" "aws04_delay" {
  provisioner "local-exec" {
    command = "sleep 300"
  }
  depends_on = [aws_instance.aws04_instance]
}

# 3. 원본 인스턴스를 이용해 AMI 생성
resource "aws_ami_from_instance" "aws04_ami" {
  name               = "${var.prefix}-instance-ami"
  source_instance_id = aws_instance.aws04_instance.id
  snapshot_without_reboot = true
  depends_on         = [null_resource.aws04_delay]
  tags = {
    Name = "${var.prefix}-instance-ami"
  }
}