#
# cycloid
#
variable "project" {}
variable "env" {}
variable "organization" {}

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

variable "stack_monitoring_node_selector" {}

variable "thanos_retention_raw" {}

variable "thanos_retention_5m" {}

variable "thanos_retention_1h" {}

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
