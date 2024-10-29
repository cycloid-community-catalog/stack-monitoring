# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}

# aws provider variables
variable "aws_access_cred" {}
variable "aws_region" {}
variable "aws_role_arn" {
  default = ""
}
variable "aws_extra_tags" {}

# cycloid credentials - passed via pipeline
variable "prometheus_domain_name" {}
variable "alertmanager_domain_name" {}
variable "grafana_domain_name" {}

# default tags to be applied in all created objects
locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
  }
  tags = merge(local.standard_tags, var.aws_extra_tags)
}