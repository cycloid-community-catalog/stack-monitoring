# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

# provider cycloid
variable "cycloid_api_url" {
  default = "https://http-api.cycloid.io"
}

variable "cycloid_api_key" {
  sensitive = true
}

# cycloid credentials - passed via pipeline
variable "aws_access_cred" {
  sensitive = true
}
variable "aws_region" {
  sensitive = true
}
variable "aws_extra_tags" {}

variable "enable_tls" {}
variable "create_self_signed_certificate" {}
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