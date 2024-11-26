#
# CYCLOID
#
variable "project" {}
variable "env" {}
variable "organization" {}

#
# GENERAL VARIABLES
#
variable "namespace" {}

variable "extra_labels" {
  default = {}
}

#variable "service_account_name" {}

#
# Opsgenie heartbeat
#
variable "opsgenie_heartbeat_install" {
  default = false
}

variable "opsgenie_token" {}

variable "stack_monitoring_node_selector" {
  default = {}
}

# Certificates

variable "enable_tls" {
  default = true
}
variable "create_self_signed_certificate"{
  default = true
}
variable "tls_crt" {}
variable "tls_key" {}

locals {

  default_labels = {
    env = "${var.env}"
    project = "${var.project}"
    stack = "stack-monitoring"
	  "app.kubernetes.io/name" = "opsgenie-heartbeat-gw"
  }
  common_labels = merge(local.default_labels, var.extra_labels)
}