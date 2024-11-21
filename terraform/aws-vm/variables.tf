# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

# cycloid credentials - passed via pipeline
variable "aws_access_cred" {}
variable "aws_region" {}
variable "aws_role_arn" {
  default = ""
}
variable "aws_extra_tags" {}

variable "ssh_to_allow" {}
variable "use_bastion" {}

variable "tls_crt" {}
variable "tls_key" {}

# default tags to be applied in all created objects
locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    Name         = "${var.organization}-vm-monitoring-${var.env}"
  }
  tags = merge(local.standard_tags, var.aws_extra_tags)
}