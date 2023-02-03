# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0


variable "aws_region_a" {
  description = "The region for AWS"
  type        = string
  default     = "ap-southeast-1"
}
variable "aws_sitename_a" {
  description = "The region for AWS"
  type        = string
  default     = "Singapore"
}
variable "aws_region_b" {
  description = "The region for AWS"
  type        = string
  default     = "us-west-1"
}
variable "aws_sitename_b" {
  description = "The region for AWS"
  type        = string
  default     = "North California"
}
variable "avi_version" {
  description = "The AVI Controller version that will be deployed"
  type        = string
}
variable "key_pair_name_a" {
  description = "The name of the existing EC2 Key pair that will be used to authenticate to the Avi Controller"
  type        = string
}
variable "key_pair_name_b" {
  description = "The name of the existing EC2 Key pair that will be used to authenticate to the Avi Controller"
  type        = string
}
variable "private_key_path" {
  description = "The local private key path for the EC2 Key pair used for authenticating to the Avi Controller. Either private_key_path or private_key_contents must be supplied."
  type        = string
  sensitive   = false
  default     = null
}
variable "private_key_contents" {
  description = "The contents of the private key for the EC2 Key pair used for authenticating to the Avi Controller. Either private_key_path or private_key_contents must be supplied."
  type        = string
  sensitive   = true
  default     = null
}
variable "controller_password" {
  description = "The password that will be used authenticating with the Avi Controller. This password be a minimum of 8 characters and contain at least one each of uppercase, lowercase, numbers, and special characters"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.controller_password) > 7
    error_message = "The controller_password value must be more than 8 characters and contain at least one each of uppercase, lowercase, numbers, and special characters."
  }
}
variable "name_prefix" {
  description = "This prefix is appended to the names of the Controller and SEs"
  type        = string
}
variable "create_networking" {
  description = "This variable controls the VPC and subnet creation for the Avi Controller. When set to false the custom_vpc_name and custom_subnetwork_name must be set."
  type        = bool
  default     = false
}
variable "create_iam" {
  description = "Create IAM Roles and Role Bindings necessary for the Avi GCP Full Access Cloud. If not set the Roles and permissions in this document must be associated with the controller service account - https://Avinetworks.com/docs/latest/gcp-full-access-roles-and-permissions/"
  type        = bool
  default     = false
}
variable "controller_ha" {
  description = "If true a HA controller cluster is deployed and configured"
  type        = bool
  default     = false
}
variable "controller_public_address" {
  description = "This variable controls if the Controller has a Public IP Address. When set to false the Ansible provisioner will connect to the private IP of the Controller."
  type        = bool
  default     = true
}
variable "configure_dns_profile" {
  description = "Configure a DNS Profile for DNS Record Creation for Virtual Services. Supported types are AWS or AVI. When set to AWS, Route 53 integration will be configured and the dns_profile_route_53_settings variable can be used when the AWS Account used is different than the Avi Controller"
  type = object({
    enabled        = bool,
    type           = string,
    usable_domains = list(string)
    aws_profile    = optional(object({ iam_assume_role = string, region = string, vpc_id = string, access_key_id = string, secret_access_key = string }))
  })
  default = { enabled = false, type = "AVI", usable_domains = [] }
  validation {
    condition     = contains(["AWS", "AVI"], var.configure_dns_profile.type)
    error_message = "Supported DNS Profile types are 'AWS' or 'AVI'"
  }
}
variable "configure_dns_vs_enable" {
  description = "Create Avi DNS Virtual Service."
  type        = bool
  default     = true
}
variable "configure_dns_vs" {
  description = "Create Avi DNS Virtual Service. The subnet_name parameter must be an existing AWS Subnet. If the allocate_public_ip parameter is set to true a EIP will be allocated for the VS. The VS IP address will automatically be allocated via the AWS IPAM"
  type        = object({ enabled = bool, subnet_name = string, allocate_public_ip = bool })
  default     = { enabled = "false", subnet_name = "", allocate_public_ip = "false" }
}
variable "aws_secret_key" {
  description = "The AWS Secret Key that will be used by Terraform and the Avi Controller resources"
  type        = string
  sensitive   = true
  default     = null
}
variable "aws_access_key" {
  description = "The AWS Access Key that will be used by Terraform and the Avi Controller resources"
  type        = string
  sensitive   = true
  default     = null
}
variable "avi_cidr_block" {
  description = "The CIDR that will be used for creating a subnet in the AVI VPC - a /16 should be provided "
  type        = string
  default     = "10.255.0.0/16"
}
variable "custom_vpc_id" {
  description = "This field can be used to specify an existing VPC for the SEs. The create-networking variable must also be set to false for this network to be used."
  type        = string
  default     = null
}
variable "custom_subnet_ids" {
  description = "This field can be used to specify a list of existing VPC Subnets for the controller and SEs. The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = null
}
variable "custom_subnet_ids_a" {
  description = "This field can be used to specify a list of existing VPC Subnets for the controller and SEs. The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = ["subnet-0b83764090556e1ea"]
}
variable "custom_subnet_ids_b" {
  description = "This field can be used to specify a list of existing VPC Subnets for the controller and SEs. The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = ["subnet-015f40b40f5472c77"]
}
variable "custom_controller_subnet_ids" {
  description = "This field can be used to specify a list of existing VPC Subnets for the Controllers.  The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = null
}
variable "jwt_token" {
  description = "This field can be used to specify JWT token to register controller"
  type        = string
  default     = null
}
variable "email" {
  description = "This field can be used to specify email address to register controller"
  type        = string
  default     = null
}
variable "organization_id" {
  description = "This field can be used to specify ORG ID to register controller"
  type        = string
  default     = null
}
variable "register_controller" {
  description = "If enabled is set to true the controller will be registered and licensed with Avi Cloud Services. The Long Organization ID (organization_id) can be found from https://console.cloud.vmware.com/csp/gateway/portal/#/organization/info. The jwt_token can be retrieved at https://portal.avipulse.vmware.com/portal/controller/auth/cspctrllogin"
  sensitive   = false
  type        = object({ enabled = bool, jwt_token = string, email = string, organization_id = string })
  default     = { enabled = "false", jwt_token = "", email = "", organization_id = "" }
}
