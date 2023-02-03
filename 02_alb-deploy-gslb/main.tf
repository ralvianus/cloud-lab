# Copyright 2021 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0

terraform {
  required_version = ">= 1.3.7"
  cloud {
    organization = "ralvianus-lab"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      tags = ["lab", "gslb"]
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias  = "a"
  region = var.aws_region_a
}
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias  = "b"
  region = var.aws_region_b
}

module "avi_controller_aws_a" {
  source                = "vmware/avi-alb-deployment-aws/aws"
  providers             = { aws = aws.a }
  version               = "1.0.6"

  region                = var.aws_region_a
  create_networking     = var.create_networking
  create_iam            = var.create_iam
  controller_ha         = var.controller_ha
  avi_version           = var.avi_version
  custom_subnet_ids            = var.custom_subnet_ids_a
  avi_cidr_block               = var.avi_cidr_block
  controller_password          = var.controller_password
  key_pair_name                = var.key_pair_name_a
  private_key_contents         = var.private_key_contents
  name_prefix                  = var.name_prefix
  controller_public_address    = var.controller_public_address

  register_controller   = { enabled = "true", jwt_token = var.jwt_token, email = var.email, organization_id = var.organization_id }
  configure_dns_profile = var.configure_dns_profile
  configure_dns_vs      = { enabled = var.configure_dns_vs_enable, allocate_public_ip = "true", subnet_name = "${var.name_prefix}-avi-subnet-${var.aws_region_a}a" }
  custom_tags           = { "Role" : "Avi-Controller", "Owner" : "ralvianus", "Department" : "VCN", "shutdown_policy" : "noshut" }
  configure_gslb        = { enabled = "true", site_name = var.aws_sitename_a }
}

module "avi_controller_aws_b" {
  source                = "vmware/avi-alb-deployment-aws/aws"
  providers             = { aws = aws.b }
  version               = "1.0.6"

  region                = var.aws_region_b
  create_networking     = var.create_networking
  create_iam            = var.create_iam
  controller_ha         = var.controller_ha
  avi_version           = var.avi_version
  custom_subnet_ids            = var.custom_subnet_ids_b
  avi_cidr_block               = var.avi_cidr_block
  controller_password          = var.controller_password
  key_pair_name                = var.key_pair_name_b
  private_key_contents         = var.private_key_contents
  name_prefix                  = var.name_prefix
  controller_public_address    = var.controller_public_address

  register_controller   = { enabled = "true", jwt_token = var.jwt_token, email = var.email, organization_id = var.organization_id }
  configure_dns_profile = var.configure_dns_profile
  configure_dns_vs      = { enabled = var.configure_dns_vs_enable, allocate_public_ip = "true", subnet_name = "${var.name_prefix}-avi-subnet-${var.aws_region_b}a" }
  custom_tags           = { "Role" : "Avi-Controller", "Owner" : "ralvianus", "Department" : "VCN", "shutdown_policy" : "noshut" }
  configure_gslb        = { enabled = "true", site_name = var.aws_sitename_a }
}