import {
  to = aws_vpc.MY-VPC
  identity = {
    id = "vpc-09eeed92514525244"
  }
}

import {
  to = aws_subnet.Public-1A
  identity = {
    id = "subnet-07415dd6c7fafb2c4"
  }
}

import {
  to = aws_security_group.ec2-jenkins

  identity = {
    id = "sg-0e08a3a57f55987aa"
  }
}

data "aws_ami" "DAJ-image" {
  owners = ["self"]

  filter {
    name   = "image-id"
    values = ["ami-096a578e6fb507c1a"]
  }
}

resource "aws_vpc" "MY-VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MY-VPC"
  }
}

resource "aws_subnet" "Public-1A" {
  vpc_id = aws_vpc.MY-VPC.id

  map_public_ip_on_launch = true

  cidr_block = var.public_subnet_cidr

  availability_zone = var.az

  tags = {
    Name = "Public-1A"
  }
}

resource "aws_security_group" "ec2-jenkins" {
  vpc_id = aws_vpc.MY-VPC.id
  description = "Allow port port 80 , 22 , 8080 inbound and all outbound trafic"
  name = "ec2-jenkins"
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.my_ip ]
  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ var.default_ip ]
  }
  ingress{
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = [ var.default_ip ]
  }
  ingress{
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    cidr_blocks = [ var.default_ip ]
  }
  ingress{
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ var.my_ip ]
  }
  ingress{
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [ var.default_ip ]
  }
  egress{
    cidr_blocks = [ var.default_ip ]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
   Name = "ec2-jenkins" 
  }
}

resource "aws_instance" "server" {
  ami = data.aws_ami.DAJ-image.id
  key_name = var.key_pair
  instance_type = var.instance_type
  subnet_id = aws_subnet.Public-1A.id
  vpc_security_group_ids = [ aws_security_group.ec2-jenkins.id ]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    encrypted = false
  }

  tags = {
    Name = "server-host"
  }
}