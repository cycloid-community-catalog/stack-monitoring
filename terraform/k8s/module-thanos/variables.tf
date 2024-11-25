#
# cycloid
#
variable "project" {}
variable "env" {}
variable "organization" {}

#
# AWS
#
# cycloid credentials - passed via pipeline
variable "aws_access_cred" {
  type = map(string)
  default = {
    access_key = null
    secret_key = null

  }
}
variable "aws_region" {
  default = null
}
variable "aws_role_arn" {
  default = null
}

#
# Thanos
#

variable "thanos_helm_version" {
  default = "15.7.7"
}

variable "namespace" {}

variable "extra_labels" {
  default = {}
}

variable "thanos_install" {
  default = false
}

variable "thanos_domain_name" {
  default = "thanos.local"
}

variable "enable_tls" {
  default = false
}
variable "tls_crt" {}
variable "tls_key" {}

variable "stack_monitoring_node_selector" {
  default = {}
}

variable "thanos_retention_raw" {
  default = "1w"
}

variable "thanos_retention_5m" {
  default = "3m"
}

variable "thanos_retention_1h" {
  default = "1y"
}

variable "thanos_object_store_secret_name" {}

locals {

  default_labels = {
    env = "${var.env}"
    project = "${var.project}"
    stack = "stack-monitoring"
  }
  common_labels = merge(local.default_labels, var.extra_labels)

  username = var.organization
}
