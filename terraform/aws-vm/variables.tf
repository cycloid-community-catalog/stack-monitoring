# Cycloid variables
variable "organization" {}
variable "project" {}
variable "env" {}
variable "component" {}

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
variable "aws_role_arn" {
  default = ""
  sensitive = true
}
variable "aws_role_external_id" {
  default = ""
  sensitive = true
}

variable "aws_extra_tags" {
  default = {}
}

variable "tls_crt" {
  default = ""
}
variable "tls_key" {
  default = ""
}
variable "enable_tls" {
  default = false
}
variable "create_self_signed_certificate" {
  default = true
}

# default tags to be applied in all created objects
locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    component    = var.component
    Name         = "${var.organization}-${var.project}-${var.env}-${var.component}"
  }
  tags = merge(local.standard_tags, var.aws_extra_tags)
}