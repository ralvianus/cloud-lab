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
variable "aws_region" {
  description = "The region for AWS"
  type        = string
  default     = "ap-southeast-1"
}
variable "create_firewall_rules" {
  description = "This variable controls the Security Group creation for the Avi deployment. When set to false the necessary security group rules must be in place before the deployment and set with the firewall_custom_security_group_ids variable"
  type        = bool
  default     = "true"
}
variable "name_prefix" {
  description = "This prefix is appended to the names of the Controller and SEs"
  type        = string
}
variable "custom_vpc_id" {
  description = "This field can be used to specify an existing VPC for the webserver. The create-networking variable must also be set to false for this network to be used."
  type        = string
  default     = null
}
variable "avi_cidr_block" {
  description = "This CIDR that will be used for creating a subnet in the AVI VPC - a /16 should be provided. This range is also used for security group rules source IP range for internal communication between the Controllers and SEs"
  type        = string
  default     = "10.255.0.0/16"
}
variable "key_pair_name" {
  description = "The name of the existing EC2 Key pair that will be used to authenticate to the Avi Controller"
  type        = string
}
variable "private_key_contents" {
  description = "The contents of the private key for the EC2 Key pair used for authenticating to the Avi Controller. Either private_key_path or private_key_contents must be supplied."
  type        = string
  sensitive   = true
  default     = null
}
variable "custom_subnet_ids" {
  description = "This field can be used to specify a list of existing VPC Subnets for the Controllers.  The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = null
}
variable "custom_tags" {
  description = "Custom tags added to AWS Resources created by the module"
  type        = map(string)
  default     = {}
}