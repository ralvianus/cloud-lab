# Copyright 2021 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0

output "controller_info_a" {
  value = module.avi_controller_aws_a.controllers
}
output "controller_info_b" {
  value = module.avi_controller_aws_b.controllers
}