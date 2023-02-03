# data "aws_ami" "webserver" {
#   most_recent = true
#   owners      = ["747965802047"]

#   filter {
#     name   = "name"
#     values = ["import-ami*"]
#   }
# }

resource "aws_security_group" "webserver_sg" {
  count       = var.create_firewall_rules ? 1 : 0
  name        = "${var.name_prefix}-webserver-sg"
  description = "Allow Traffic for webserver"
  vpc_id      = var.create_networking ? avi_controller_aws.aws_vpc.avi[0].id : var.custom_vpc_id

  ingress {
    description = "SSH Ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.firewall_controller_allow_source_range]
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
  ami           = "ami-026b3090059d3381b"
  key_name      = var.key_pair_name
  root_block_device {
    volume_size           = 20
    delete_on_termination = true
    encrypted             = var.controller_ebs_encryption
    kms_key_id            = var.controller_ebs_encryption ? var.controller_ebs_encryption_key_arn == null ? module.avi_controller_aws.data.aws_kms_alias.ebs[0].target_key_arn : var.controller_ebs_encryption_key_arn : null
  }
  subnet_id                   = var.create_networking ? aws_subnet.avi[count.index].id : var.custom_controller_subnet_ids[count.index]
  vpc_security_group_ids      = aws_security_group.webserver_sg[0].id
  iam_instance_profile        = var.create_iam ? module.avi_controller_aws.aws_iam_instance_profile.avi[0].id : null
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