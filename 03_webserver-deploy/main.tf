terraform {
  required_version = ">= 1.3.7"
  cloud {
    organization = "ralvianus-lab"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      tags = ["lab", "webserver"]
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

data "aws_ami" "webserver" {
  most_recent = true
  owners      = ["747965802047"]

  filter {
    name   = "name"
    values = ["ralvianus-webserver"]
  }
}

data "aws_kms_alias" "ebs" {
  count = 1
  name = "alias/aws/ebs"
}

resource "aws_security_group" "webserver_sg" {
  count       = var.create_firewall_rules ? 1 : 0
  name        = "${var.name_prefix}-webserver-sg"
  description = "Allow Traffic for webserver"
  vpc_id      = var.custom_vpc_id

  ingress {
    description = "SSH Ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.avi_cidr_block]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.avi_cidr_block]
  }
  egress {
    description = "Allow traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-webserver-sg"
  }
}

resource "aws_instance" "webserver_instance" {
  count         = 2
  instance_type = "t2.micro"
  ami           = data.aws_ami.webserver.id
  key_name      = var.key_pair_name
  root_block_device {
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_alias.ebs[0].target_key_arn
  }
  subnet_id                   = var.custom_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.webserver_sg[0].id]
  associate_public_ip_address = false
  tags = {
    Name = "${var.name_prefix}-webserver-${count.index + 1}"
  }
  lifecycle {
    ignore_changes = [tags, associate_public_ip_address, root_block_device[0].tags]
  }
}

resource "aws_ec2_tag" "webserver_tag" {
  for_each    = var.custom_tags
  resource_id = aws_instance.webserver_instance[0].id
  key         = each.key
  value       = each.value
}