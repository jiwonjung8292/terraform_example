# main.tf

# 1. vpc 생성
resource "aws_vpc" "aws04_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.prefix}-vpc"
  }
}
# 2. subnet생성
resource "aws_subnet" "aws04_public_subnet" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.aws04_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "${var.prefix}-public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "aws04_private_subnet" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.aws04_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "${var.prefix}-private-subnet-${count.index + 1}"
  }
}

# 3. Internet Gateway 생성 및 VPC에 연결
resource "aws_internet_gateway" "aws04_igw" {
  vpc_id = aws_vpc.aws04_vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}
# 4. NAT Gateway 생성 및 Public Subnet에 연결
resource "aws_eip" "aws04_nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "aws04_nat_gw" {
  allocation_id = aws_eip.aws04_nat_eip.id
  subnet_id     = aws_subnet.aws04_public_subnet[0].id
  tags = {
    Name = "${var.prefix}-nat-gw"
  }
}
# 5. Route Table 생성 및 라우팅 설정(Public 1개, Private 2개)
resource "aws_route_table" "aws04_public_rt" {
  vpc_id = aws_vpc.aws04_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws04_igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}
resource "aws_route_table_association" "aws04_public_rt_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.aws04_public_subnet[count.index].id
  route_table_id = aws_route_table.aws04_public_rt.id
}
resource "aws_route_table" "aws04_private_rt" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.aws04_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws04_nat_gw.id
  }
  tags = {
    Name = "${var.prefix}-private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "aws04_private_rt_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.aws04_private_subnet[count.index].id
  route_table_id = aws_route_table.aws04_private_rt[count.index].id
}
# 6. Security Group 생성 - SSH-SG, HTTP-SG
resource "aws_security_group" "aws04_ssh_sg" {
  name        = "${var.prefix}-ssh-sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.aws04_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-ssh-sg"
  }
}
resource "aws_security_group" "aws04_http_sg" {
  name        = "${var.prefix}-http-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.aws04_vpc.id
  
  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}-http-sg"
  }
}