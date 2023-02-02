## Overview
This repository contains Terraform code for infrastructure as code (IAC) provisioning. Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.

## Requirements

- Terraform 1.3.7
- A Terraform cloud account
- Familiarity with Terraform and IAC concepts

## Getting Started

1.  Clone this repository to your local machine
2. Change to the repository directory
3. Run `terraform init` to initialize the Terraform working directory
4. Run `terraform plan` to see a preview of the changes that will be made
5. If the preview looks good, run `terraform apply` to apply the changes

## File Structure

The Terraform code in this repository is organized as follows:

- `main.tf`: the main Terraform configuration file
- `variables.tf`: the Terraform variable definitions
- `outputs.tf`: the Terraform output definitions

Below is the example of `terraform.tfvars` 
```
# AWS key
aws_access_key = ""
aws_secret_key = ""

# AWS Networking
create_networking    = "true"
avi_cidr_block       = "10.154.0.0/16"
create_iam           = "true"
custom_subnet_ids    = [""]
key_pair_name        = ""
private_key_contents = <<EOT
-----BEGIN RSA PRIVATE KEY-----

-----END RSA PRIVATE KEY-----
EOT

# AVI Parameters
avi_version               = "21.1.6"
controller_password       = ""
name_prefix               = ""
controller_ha             = "false"
controller_public_address = "true"
email                     = ""
organization_id           = ""
jwt_token                 = ""

configure_dns_profile = { enabled = "true", type = "AVI", usable_domains = ["ralvianus.demoavi.us"] }
configure_dns_vs      = { enabled = "true", allocate_public_ip = "true", subnet_name = "" }

```

## License

This code is licensed under the [MIT License](/LICENSE).