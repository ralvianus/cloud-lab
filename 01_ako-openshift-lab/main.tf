# Copyright 2021 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0

terraform {
  required_version = ">= 1.3.7"
  cloud {
    organization = "ralvianus-lab"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      tags = ["lab", "ako"]
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

}
module "avi_controller_aws" {
  source  = "vmware/avi-alb-deployment-aws/aws"
  version = "1.0.6"

  region                    = "us-west-1"
  aws_access_key            = var.aws_access_key
  aws_secret_key            = var.aws_secret_key
  create_networking         = var.create_networking
  create_iam                = var.create_iam
  avi_version               = var.avi_version
  custom_vpc_id             = var.custom_vpc_id
  custom_subnet_ids         = var.custom_subnet_ids
  avi_cidr_block            = var.avi_cidr_block
  controller_password       = var.controller_password
  key_pair_name             = var.key_pair_name
  private_key_path          = var.private_key_path
  name_prefix               = var.name_prefix
  controller_ha             = var.controller_ha
  controller_public_address = var.controller_public_address
  configure_dns_profile     = var.configure_dns_profile
  dns_service_domain        = var.dns_service_domain
  configure_dns_vs          = var.configure_dns_vs
  dns_vs_settings           = var.dns_vs_settings
  configure_cloud           = "true"
  custom_tags               = { "Role" : "Avi-Controller", "Owner" : "ralvianus", "Department" : "VCN", "shutdown_policy" : "noshut" }
}